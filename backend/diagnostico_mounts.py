import sys
import os

# Define variáveis de ambiente necessárias antes de importar app.main
os.environ.setdefault("DATABASE_URL", "sqlite:///:memory:")
os.environ.setdefault("ADMIN_API_KEY", "test-key")
os.environ.setdefault("SECRET_KEY", "test-secret")

# Define o diretório de trabalho como backend para que as importações funcionem corretamente
backend_dir = os.path.abspath(os.path.dirname(os.path.abspath(__file__)))
os.chdir(backend_dir)

# Adiciona o diretório backend ao sys.path se não estiver presente
if backend_dir not in sys.path:
    sys.path.insert(0, backend_dir)

print(f"Diretorio de trabalho: {os.getcwd()}")
print(f"sys.path[0]: {sys.path[0]}")
print()

# Importa o modulo app.main
try:
    import app.main as app_main
    print(f"app.main.__file__: {app_main.__file__}")
    print(f"app.main.__name__: {app_main.__name__}")
except Exception as e:
    print(f"ERRO ao importar app.main: {type(e).__name__}: {e}")
    sys.exit(1)

# Verifica se o objeto app existe e é uma instancia de FastAPI
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

    # Para StaticFiles, tentar obter o diretorio
    directory = None
    if hasattr(route, "directory"):
        directory = str(route.directory)

    print(f"  Path: {route_path}")
    print(f"    Name: {route_name}")
    print(f"    Type: {route_type}")
    print(f"    Directory: {directory}")
    print()

# Verifica se existem os mounts esperados
print("=== Verificacao de Monts Esperados ===")
expected_mounts = ["/static", "/admin", "/"]
for mount_path in expected_mounts:
    found = False
    for route in app.router.routes:
        if getattr(route, "path", None) == mount_path:
            found = True
            directory = getattr(route, "directory", None)
            print(f"  {mount_path}: ENCONTRADO - directory={directory}")
            break
    if not found:
        print(f"  {mount_path}: NAO ENCONTRADO")

print()
print("=== Verificacao de Arquivos Estaticos ===")
static_dir = os.path.join(os.path.dirname(app_main.__file__), "static")
print(f"static_dir: {static_dir}")
print(f"static_dir existe: {os.path.isdir(static_dir)}")

plantas_dir = os.path.join(static_dir, "plantas")
print(f"plantas_dir: {plantas_dir}")
print(f"plantas_dir existe: {os.path.isdir(plantas_dir)}")

demo_svg = os.path.join(plantas_dir, "demo.svg")
print(f"demo.svg: {demo_svg}")
print(f"demo.svg existe: {os.path.isfile(demo_svg)}")

visitor_dist = os.path.join(static_dir, "visitor")
print(f"visitor_dist: {visitor_dist}")
print(f"visitor_dist existe: {os.path.isdir(visitor_dist)}")

visitor_index = os.path.join(visitor_dist, "index.html")
print(f"visitor_index.html: {visitor_index}")
print(f"visitor_index.html existe: {os.path.isfile(visitor_index)}")

admin_dist = os.path.join(static_dir, "admin")
print(f"admin_dist: {admin_dist}")
print(f"admin_dist existe: {os.path.isdir(admin_dist)}")

print("\n=== Fim do Diagnostico ===")