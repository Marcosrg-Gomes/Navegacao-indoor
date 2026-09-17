"""Probe the configured launcher without changing hooks, PATH or Codex settings.

Run from the repository root: python evidence/verify_hook_launcher.py
This is a local reproduction, not a captured Codex hook event.
"""
import hashlib
import json
import os
from pathlib import Path
import subprocess
from datetime import datetime, timezone


def run(argv, env, payload="{}"):
    result = subprocess.run(argv, input=payload.encode(), capture_output=True,
                            env=env, timeout=30,
                            creationflags=subprocess.CREATE_NO_WINDOW)
    def decode(data):
        return data.decode("utf-16" if b"\x00" in data else "utf-8", errors="replace")
    return {"argv": argv, "exit_code": result.returncode,
            "stdout": decode(result.stdout), "stderr": decode(result.stderr)}


plugin = Path.home() / ".codex/plugins/cache/alexgreensh-token-optimizer/token-optimizer/5.13.12"
source = plugin / "hooks/hooks.json"
config = json.loads(source.read_text(encoding="utf-8"))
env = dict(os.environ, CLAUDE_PLUGIN_ROOT=plugin.as_posix())
report = {"executed_at_utc": datetime.now(timezone.utc).isoformat(),
          "scope": "Manual subprocess reproduction; original Codex event not available",
          "source": str(source), "sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
          "powershell_probes": []}
for event, index in [("PreToolUse", 1), ("PostToolUse", 0), ("UserPromptSubmit", 0), ("Stop", 0)]:
    entry = config["hooks"][event][index]
    command = entry["hooks"][0]["command"]
    probe = run(["powershell.exe", "-NoProfile", "-Command", command], env)
    report["powershell_probes"].append({"event": event, "matcher": entry.get("matcher"), **probe})
command = config["hooks"]["PreToolUse"][1]["hooks"][0]["command"]
git_bash = Path(os.environ["ProgramFiles"]) / "Git/bin/bash.exe"
report["wsl_alias"] = run([str(Path.home() / "AppData/Local/Microsoft/WindowsApps/bash.exe"), "--version"], env)
report["git_bash_version"] = run([str(git_bash), "--version"], env)
# The explicit shell and child-only PATH ensure both levels use Git Bash.
git_env = dict(env, PATH=str(git_bash.parent) + os.pathsep + env["PATH"])
payload = json.dumps({"hook_event_name": "PreToolUse", "tool_name": "Bash",
                      "tool_input": {"command": "git status --short"},
                      "cwd": str(Path.cwd()), "session_id": "indoor-launcher-probe"})
report["git_bash_configured_command"] = run([str(git_bash), "-c", command], git_env, payload)
target = Path(__file__).with_name("resume-hook-launcher.json")
target.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
for probe in report["powershell_probes"]:
    print(probe["event"], probe["matcher"], probe["exit_code"])
for key in ["wsl_alias", "git_bash_version", "git_bash_configured_command"]:
    print(key, report[key]["exit_code"])
print(target)
