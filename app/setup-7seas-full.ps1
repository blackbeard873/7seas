# PowerShell script to set up a complete FastAPI 7seas project

param (
[string]$ProjectPath = "C:\projects\7seas"
)

# Function to write file content

function Write-File {
param(
[string]$Path,
[string]$Content
)
$Content | Out-File -FilePath $Path -Encoding utf8 -Force
}

# Clean project folder

if (Test-Path $ProjectPath) {
Write-Host "Cleaning project folder..."
Remove-Item $ProjectPath -Recurse -Force
}

# Create folder structure

Write-Host "Creating folder structure..."
New-Item -ItemType Directory -Path $ProjectPath\app\routers -Force | Out-Null
New-Item -ItemType Directory -Path $ProjectPath\app\models -Force | Out-Null
New-Item -ItemType Directory -Path $ProjectPath\app\tests -Force | Out-Null

# Create **init**.py files

Write-Host "Creating **init**.py files..."
Write-File "$ProjectPath\app_*init*_.py" ""
Write-File "$ProjectPath\app\routers_*init*_.py" ""
Write-File "$ProjectPath\app\models_*init*_.py" ""
Write-File "$ProjectPath\app\tests_*init*_.py" ""

# Create main.py with automatic router discovery

Write-Host "Creating main.py with auto-router discovery..."
$mainContent = @"
from fastapi import FastAPI
import importlib
import pkgutil
from app.routers import **path** as routers_path

app = FastAPI()

# Automatically import all modules in app.routers and include APIRouter instances

for _, module_name, _ in pkgutil.iter_modules(routers_path):
module = importlib.import_module(f"app.routers.{module_name}")
if hasattr(module, "router"):
app.include_router(module.router)

@app.get("/")
def read_root():
return {"message": "7seas API is running!"}
"@
Write-File "$ProjectPath\app\main.py" $mainContent

# Create example router

Write-Host "Creating example routers..."
$exampleRouter = @"
from fastapi import APIRouter

router = APIRouter()

@router.get('/example')
def example():
return {'message': 'This is an example route.'}
"@
Write-File "$ProjectPath\app\routers/example.py" $exampleRouter

# Create example database.py

Write-Host "Creating example database.py..."
$databaseContent = @"
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "sqlite+aiosqlite:///./7seas.db"

engine = create_async_engine(DATABASE_URL, echo=True)
AsyncSessionLocal = sessionmaker(engine, expire_on_commit=False, class_=AsyncSession)
"@
Write-File "$ProjectPath\app/models/database.py" $databaseContent

# Create example model

Write-Host "Creating example model.py..."
$modelContent = @"
from sqlalchemy import Column, Integer, String
from .database import engine
from sqlalchemy.orm import declarative_base

Base = declarative_base()

class ExampleModel(Base):
**tablename** = 'examples'
id = Column(Integer, primary_key=True, index=True)
name = Column(String, index=True)
"@
Write-File "$ProjectPath\app/models/example.py" $modelContent

# Create example test file

Write-Host "Creating example test files..."
$testBasic = @"
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_root():
response = client.get('/')
assert response.status_code == 200
assert response.json() == {'message': '7seas API is running!'}
"@
Write-File "$ProjectPath\app/tests/test_basic.py" $testBasic

$testExample = @"
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_example():
response = client.get('/example')
assert response.status_code == 200
assert 'message' in response.json()
"@
Write-File "$ProjectPath\app/tests/test_example.py" $testExample

# Create .gitignore

Write-Host "Creating .gitignore..."
$gitignore = @"
.venv/
**pycache**/
*.pyc
*.pyo
*.pyd
*.sqlite3
.env
.vscode/
.idea/
"@
Write-File "$ProjectPath.gitignore" $gitignore

# Create README.md

Write-Host "Creating README.md..."
$readme = @"

# 7seas FastAPI Project

This is the 7seas MMORPG backend built with FastAPI, SQLAlchemy 2.0, and Pydantic v2.

## Setup

```powershell
cd 7seas
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install fastapi uvicorn sqlalchemy aiosqlite pydantic httpx
uvicorn app.main:app --reload
```

## Testing

```powershell
pytest -v
```

"@
Write-File "$ProjectPath\README.md" $readme

# Create MIT LICENSE with blackbeard873

Write-Host "Creating LICENSE..."
$year = (Get-Date).Year
$license = @"
MIT License

Copyright (c) $year blackbeard873

Permission is hereby granted, free of charge, to any person obtaining a copy
...
[Full MIT license text here]
...
"@
Write-File "$ProjectPath\LICENSE" $license

Write-Host "Setup complete! Next steps:"
Write-Host "1. Navigate to project folder: cd $ProjectPath"
Write-Host "2. Create and activate virtual environment:"
Write-Host "   python -m venv .venv"
Write-Host "   ..venv\Scripts\Activate.ps1"
Write-Host "3. Install dependencies:"
Write-Host "   pip install fastapi uvicorn sqlalchemy aiosqlite pydantic httpx pytest"
Write-Host "4. Run server: uvicorn app.main:app --reload"
Write-Host "5. Run tests: pytest -v"
