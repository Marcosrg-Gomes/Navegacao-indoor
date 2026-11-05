import sys
import os
import subprocess
import time
import requests

# Define o diretório de trabalho como backend para que as importações funcionem corretamente
backend_dir = os.path.abspath(os.path.dirname(os.path.abspath(__file__)))
os.chdir(backend_dir)

print(f"Diretório de trabalho: {os.getcwd()}")
print(f"Iniciando servidor de auditoria na porta 8766...")

# Inicia o servidor de auditoria como subprocesso
proc = None
try:
    proc = subprocess.Popen(
        [sys.executable, "audit_server.py", "--port", "8766"],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        cwd=backend_dir,
        text=True,
    )
    print(f"Processo iniciado com PID: {proc.pid}")
except Exception as e:
    print(f"ERRO ao iniciar servidor: {type(e).__name__}: {e}")
    sys.exit(1)

# Aguarda até 15 segundos pela inicialização do servidor
servidor_pronto = False
for i in range(30):
    try:
        resp = requests.get("http://127.0.0.1:8766/health", timeout=2)
        if resp.status_code == 200:
            servidor_pronto = True
            print(f"Servidor respondeu na porta 8766 após {i+1} tentativas")
            break
    except Exception:
        pass
    time.sleep(0.5)

if not servidor_pronto:
    print("ERRO: Servidor não respondeu após 15 segundos")
    try:
        proc.terminate()
        proc.wait(timeout=5)
    except Exception:
        proc.kill()
    sys.exit(1)

print("\n=== Executando requisições HTTP ===\n")

# Requisição 1: /health
print("\n--- Requisição: GET /health ---")
try:
    resp = requests.get("http://127.0.0.1:8766/health", timeout=10)
    print(f"  Status: {resp.status_code}")
    print(f"  Content-Type: {resp.headers.get('content-type', 'N/A')}")
    print(f"  Corpo: {resp.text[:200]!r}")
except Exception as e:
    print(f"  ERRO: {type(e).__name__}: {e}")

# Requisição 2: /static/plantas/demo.svg
print("\n--- Requisição: GET /static/plantas/demo.svg ---")
try:
    resp = requests.get("http://127.0.0.1:8766/static/plantas/demo.svg", timeout=10)
    print(f"  Status: {resp.status_code}")
    print(f"  Content-Type: {resp.headers.get('content-type', 'N/A')}")
    print(f"  Corpo (primeiros 100 bytes): {repr(resp.content[:100]) if resp.content else 'vazio'}")
except Exception as e:
    print(f"  ERRO: {type(e).__name__}: {e}")

# Requisição 3: GET /?qr=ENTRADA-PRINCIPAL
print("\n--- Requisição: GET /?qr=ENTRADA-PRINCIPAL ---")
try:
    resp = requests.get("http://127.0.0.1:8766/?qr=ENTRADA-PRINCIPAL", timeout=10)
    print(f"  Status: {resp.status_code}")
    print(f"  Content-Type: {resp.headers.get('content-type', 'N/A')}")
    print(f"  Corpo (primeiros 200 chars): {resp.text[:200]!r}")
except Exception as e:
    print(f"  ERRO: {type(e).__name__}: {e}")

# Requisição 4: GET /admin/
print("\n--- Requisição: GET /admin/ ---")
try:
    resp = requests.get("http://127.0.0.1:8766/admin/", timeout=10)
    print(f"  Status: {resp.status_code}")
    print(f"  Content-Type: {resp.headers.get('content-type', 'N/A')}")
    print(f"  Corpo (primeiros 200 chars): {resp.text[:200]!r}")
except Exception as e:
    print(f"  ERRO: {type(e).__name__}: {e}")

# Encerra o servidor
print("\n--- Encerrando servidor ---")
try:
    proc.terminate()
    proc.wait(timeout=10)
    print("Servidor encerrado com sucesso")
except Exception as e:
    print(f"AVISO: Erro ao encerrar servidor: {type(e).__name__}: {e}")
    try:
        proc.kill()
        proc.wait(timeout=5)
        print("Servidor encerrado forçadamente")
    except Exception as e2:
        print(f"ERRO ao encerrar forçadamente: {type(e2).__name__}: {e2}")

print("\n=== Fim do Diagnóstico ===")