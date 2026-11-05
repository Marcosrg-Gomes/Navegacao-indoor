import sys
import os
import asyncio

# Define o diretório de trabalho como backend para que as importações funcionem corretamente
backend_dir = os.path.abspath(os.path.dirname(os.path.abspath(__file__)))
os.chdir(backend_dir)

# Adiciona o diretório backend ao sys.path se não estiver presente
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)

print(f"Diretório de trabalho: {os.getcwd()}")
print(f"sys.path[0]: {sys.path[0]}")
print()

# Define variáveis de ambiente necessárias antes de importar app.main
os.environ.setdefault("DATABASE_URL", "sqlite:///:memory:")
os.environ.setdefault("ADMIN_API_KEY", "test-key")
os.environ.setdefault("SECRET_KEY", "test-secret")

# Importa o módulo app.main
try:
    import app.main as app_main
    print(f"app.main.__file__: {app_main.__file__}")
    print(f"app.main.__name__: {app_main.__name__}")
except Exception as e:
    print(f"ERRO ao importar app.main: {type(e).__name__}: {e}")
    sys.exit(1)

app = app_main.app
print(f"\nTipo do objeto app: {type(app).__name__}")
print(f"app.title: {app.title}")
print(f"app.version: {app.version}")
print()

# Lista os mounts registrados no router
print("=== Mounts e Rotas Registradas no Objeto app ===")
for route in app.router.routes:
    route_path = getattr(route, "path", None)
    route_name = getattr(route, "name", None)
    route_type = type(route).__name__
    directory = getattr(route, "directory", None)

    print(f"  Path: {route_path}")
    print(f"    Name: {route_name}")
    print(f"    Type: {route_type}")
    print(f"    Directory: {directory}")
    print()

# Teste isolado com httpx.ASGITransport (sem iniciar servidor TCP)
print("=== Teste de Requisições ASGI Isoladas ===")

try:
    import httpx
    print(f"httpx versão: {httpx.__version__}")
except ImportError:
    print("ERRO: httpx não está disponível. Não é possível executar requisições ASGI isoladas.")
    sys.exit(1)

async def test_requests():
    transport = httpx.ASGITransport(app=app)

    async with httpx.AsyncClient(transport=transport, base_url="http://testserver") as client:
        # Requisição 1: /health
        print("\n--- Requisição: GET /health ---")
        try:
            resp = await client.get("/health", timeout=10)
            print(f"  Status: {resp.status_code}")
            print(f"  Content-Type: {resp.headers.get('content-type', 'N/A')}")
            body = resp.text[:200] if resp.text else ""
            print(f"  Corpo (primeiros 200 chars): {body!r}")
        except Exception as e:
            print(f"  ERRO: {type(e).__name__}: {e}")

        # Requisição 2: /static/plantas/demo.svg
        print("\n--- Requisição: GET /static/plantas/demo.svg ---")
        try:
            resp = await client.get("/static/plantas/demo.svg", timeout=10)
            print(f"  Status: {resp.status_code}")
            print(f"  Content-Type: {resp.headers.get('content-type', 'N/A')}")
            body_preview = repr(resp.content[:100]) if resp.content else ""
            print(f"  Corpo (primeiros 100 bytes): {body_preview}")
        except Exception as e:
            print(f"  ERRO: {type(e).__name__}: {e}")

        # Requisição 3: GET /
        print("\n--- Requisição: GET / ---")
        try:
            resp = await client.get("/", timeout=10)
            print(f"  Status: {resp.status_code}")
            print(f"  Content-Type: {resp.headers.get('content-type', 'N/A')}")
            body = resp.text[:200] if resp.text else ""
            print(f"  Corpo (primeiros 200 chars): {body!r}")
        except Exception as e:
            print(f"  ERRO: {type(e).__name__}: {e}")

        # Requisição 4: GET /?qr=ENTRADA-PRINCIPAL
        print("\n--- Requisição: GET /?qr=ENTRADA-PRINCIPAL ---")
        try:
            resp = await client.get("/?qr=ENTRADA-PRINCIPAL", timeout=10)
            print(f"  Status: {resp.status_code}")
            print(f"  Content-Type: {resp.headers.get('content-type', 'N/A')}")
            body = resp.text[:200] if resp.text else ""
            print(f"  Corpo (primeiros 200 chars): {body!r}")
        except Exception as e:
            print(f"  ERRO: {type(e).__name__}: {e}")

        # Requisição 5: GET /admin/
        print("\n--- Requisição: GET /admin/ ---")
        try:
            resp = await client.get("/admin/", timeout=10)
            print(f"  Status: {resp.status_code}")
            print(f"  Content-Type: {resp.headers.get('content-type', 'N/A')}")
            body = resp.text[:200] if resp.text else ""
            print(f"  Corpo (primeiros 200 chars): {body!r}")
        except Exception as e:
            print(f"  ERRO: {type(e).__name__}: {e}")

asyncio.run(test_requests())

print("\n=== Fim do Diagnóstico ===")