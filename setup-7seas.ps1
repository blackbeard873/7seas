# -----------------------------

# Full 7seas Project Setup Script

# -----------------------------

# Prompt for GitHub repo URL

$githubRepo = Read-Host "Enter your GitHub repository URL (or leave blank to skip push)"

# Root project path

$rootPath = "C:\projects\7seas"

# -------------------------

Write-Host "`nCleaning project folder..."
Get-ChildItem $rootPath -Force | Where-Object { $_.FullName -ne $MyInvocation.MyCommand.Definition } | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Creating folder structure..."
$folders = @(
"$rootPath\app",
"$rootPath\app\routers",
"$rootPath\app\models",
"$rootPath\app\tests"
)
foreach ($folder in $folders) { New-Item -ItemType Directory -Path $folder -Force | Out-Null }

Write-Host "Creating **init**.py files..."
$initPaths = @(
"$rootPath\app_*init*_.py",
"$rootPath\app\routers_*init*_.py",
"$rootPath\app\models_*init*_.py",
"$rootPath\app\tests_*init*_.py"
)
foreach ($initPath in $initPaths) { New-Item -ItemType File -Path $initPath -Force | Out-Null }

# --- main.py ---

$mainPath = "$rootPath\app\main.py"
$mainContent = @"
from fastapi import FastAPI
from app.routers import example

app = FastAPI()
app.include_router(example.router)

@app.get('/')
def read_root():
return {'message': '7seas API is running!'}
"@
$mainContent | Out-File -FilePath $mainPath -Encoding utf8 -Force

# --- example router ---

$exampleRouterPath = "$rootPath\app\routers/example.py"
$exampleRouterContent = @"
from fastapi import APIRouter

router = APIRouter()

@router.get('/example')
def example_route():
return {'example': 'This is an example route'}
"@
$exampleRouterContent | Out-File -FilePath $exampleRouterPath -Encoding utf8 -Force

# --- database.py ---

$dbPath = "$rootPath\app\models/database.py"
$dbContent = @"
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker, declarative_base

DATABASE_URL = 'sqlite+aiosqlite:///./7seas.db'

engine = create_async_engine(DATABASE_URL, echo=True)
async_session = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
Base = declarative_base()
"@
$dbContent | Out-File -FilePath $dbPath -Encoding utf8 -Force

# --- model ---

$modelPath = "$rootPath\app\models/player.py"
$modelContent = @"
from sqlalchemy import Column, Integer, String
from .database import Base

class Player(Base):
**tablename** = 'players'
id = Column(Integer, primary_key=True, index=True)
name = Column(String, index=True)
level = Column(Integer, default=1)
"@
$modelContent | Out-File -FilePath $modelPath -Encoding utf8 -Force

# --- test file ---

$testPath = "$rootPath\app/tests/test_basic.py"
$testContent = @"
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_root():
response = client.get('/')
assert response.status_code == 200
assert response.json() == {'message': '7seas API is running!'}
"@
$testContent | Out-File -FilePath $testPath -Encoding utf8 -Force

# --- .gitignore ---

$gitignorePath = "$rootPath.gitignore"
$gitignoreContent = @"

# Virtual environment

.venv/

# Python bytecode

**pycache**/
*.pyc
*.pyo
*.pyd

# Database files

*.sqlite3

# Environment files

.env

# IDE/editor files

.vscode/
.idea/
*.sublime-project
*.sublime-workspace

# OS files

.DS_Store
Thumbs.db

# Logs

*.log

# Coverage reports

htmlcov/
.coverage
"@
$gitignoreContent | Out-File -FilePath $gitignorePath -Encoding utf8 -Force

# --- README.md ---

$readmePath = "$rootPath\README.md"
$readmeContent = @"

# 7seas - FastAPI MMORPG Project

7seas is a FastAPI-based MMORPG backend project.
This repository includes routes, models, and test setup for a fully async Python API project.

## Getting Started

```powershell
cd C:\projects\7seas
python -m venv .venv
..venv\Scripts\Activate.ps1
pip install fastapi uvicorn sqlalchemy aiosqlite pydantic httpx
uvicorn app.main:app --reload
pytest -v
```

## License

[MIT License](LICENSE)
"@
$readmeContent | Out-File -FilePath $readmePath -Encoding utf8 -Force

# --- MIT LICENSE ---

$licensePath = "$rootPath\LICENSE"
$licenseContent = @"
MIT License

Copyright (c) $(Get-Date -Format yyyy) blackbeard873

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
"@
$licenseContent | Out-File -FilePath $licensePath -Encoding utf8 -Force

# --- Git initialization ---

Write-Host "`nInitializing Git repository..."
Set-Location $rootPath
git init
git add .
git commit -m "Initial commit: working FastAPI 7seas project"

# Optional: push to GitHub

if ($githubRepo -ne "") {
git remote add origin $githubRepo
git branch -M main
Write-Host "Pushing to GitHub..."
git push -u origin main
}

# --- Create and activate virtual environment ---

Write-Host "`nCreating and activating virtual environment..."
python -m venv .venv
& ..venv\Scripts\Activate.ps1

# --- Install dependencies ---

Write-Host "`nInstalling dependencies..."
pip install fastapi uvicorn sqlalchemy aiosqlite pydantic httpx pytest

Write-Host "`n✅ Project setup complete!"
Write-Host "Next steps:"
Write-Host "1. uvicorn app.main:app --reload"
Write-Host "2. pytest -v"
Write-Host "3. Verify your GitHub repository and README.md"
