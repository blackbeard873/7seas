# setup-7seas.ps1
# Creates a complete FastAPI MMORPG project structure

Write-Host "⚓ Setting up 7seas FastAPI project..."

# Step 1: Clean old folder
if (Test-Path ".\7seas") {
    Write-Host "🧹 Removing old 7seas folder..."
    Remove-Item -Recurse -Force ".\7seas"
}

# Step 2: Create folder structure
Write-Host "📁 Creating new folder structure..."
New-Item -ItemType Directory -Path ".\7seas\app\models" | Out-Null
New-Item -ItemType Directory -Path ".\7seas\app\routers" | Out-Null
New-Item -ItemType Directory -Path ".\7seas\app\tests" | Out-Null

# Step 3: Create __init__.py files
'' | Set-Content ".\7seas\app\__init__.py"
'' | Set-Content ".\7seas\app\models\__init__.py"
'' | Set-Content ".\7seas\app\routers\__init__.py"
'' | Set-Content ".\7seas\app\tests\__init__.py"

# Step 4: Create main.py
@'
from fastapi import FastAPI
from app.routers import players, factions, auth
from app.database import create_db_and_tables

app = FastAPI(title="7seas MMORPG API")

app.include_router(players.router, prefix="/players", tags=["players"])
app.include_router(factions.router, prefix="/factions", tags=["factions"])
app.include_router(auth.router, prefix="/auth", tags=["auth"])

@app.on_event("startup")
async def on_startup():
    await create_db_and_tables()
'@ | Set-Content ".\7seas\app\main.py"

# Step 5: Create database.py
@'
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker, declarative_base

DATABASE_URL = "sqlite+aiosqlite:///./7seas.db"

engine = create_async_engine(DATABASE_URL, echo=True)
async_session = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)
Base = declarative_base()

async def create_db_and_tables():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
'@ | Set-Content ".\7seas\app\database.py"

# Step 6: Create models
@'
from sqlalchemy import Integer, String, ForeignKey, Column
from app.database import Base

class Player(Base):
    __tablename__ = "players"
    id = Column(Integer, primary_key=True)
    name = Column(String, unique=True, nullable=False)
    faction_id = Column(Integer, ForeignKey("factions.id"), nullable=True)
'@ | Set-Content ".\7seas\app\models\player.py"

@'
from sqlalchemy import Integer, String, Column
from app.database import Base

class Faction(Base):
    __tablename__ = "factions"
    id = Column(Integer, primary_key=True)
    name = Column(String, unique=True, nullable=False)
'@ | Set-Content ".\7seas\app\models\faction.py"

# Step 7: Routers
@'
from fastapi import APIRouter
router = APIRouter()

@router.get("/")
async def list_players():
    return {"players": []}
'@ | Set-Content ".\7seas\app\routers\players.py"

@'
from fastapi import APIRouter
router = APIRouter()

@router.get("/")
async def list_factions():
    return {"factions": []}
'@ | Set-Content ".\7seas\app\routers\factions.py"

@'
from fastapi import APIRouter
router = APIRouter()

@router.post("/login")
async def login(username: str, password: str):
    return {"username": username, "status": "logged in"}
'@ | Set-Content ".\7seas\app\routers\auth.py"

# Step 8: Tests
@'
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_read_main():
    response = client.get("/players/")
    assert response.status_code == 200
    assert "players" in response.json()
'@ | Set-Content ".\7seas\app\tests\test_main.py"

# Step 9: requirements.txt
@'
fastapi==0.111.1
uvicorn==0.26.1
sqlalchemy==2.0.21
pydantic==2.8.0
aiosqlite==0.19.0
'@ | Set-Content ".\7seas\requirements.txt"

# Step 10: .gitignore
@'
.venv/
__pycache__/
*.pyc
.env
'@ | Set-Content ".\7seas\.gitignore"

# Step 11: Create venv
Write-Host "🐍 Creating virtual environment..."
python -m venv ".\7seas\.venv"

Write-Host "`n✅ Setup complete!"
Write-Host "Next steps:"
Write-Host "1. cd 7seas"
Write-Host "2. .\\.venv\\Scripts\\Activate.ps1"
Write-Host "3. pip install -r requirements.txt"
Write-Host "4. uvicorn app.main:app --reload"
