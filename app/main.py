from fastapi import FastAPI
import importlib
import pkgutil
from app.routers import **path** as routers_path

app = FastAPI()

# Auto-include all routers in app.routers

for _, module_name, _ in pkgutil.iter_modules(routers_path):
module = importlib.import_module(f'app.routers.{module_name}')
if hasattr(module, 'router'):
app.include_router(module.router)

@app.get("/")
def read_root():
return {"message": "7seas API is running!"}
