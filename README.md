
# 7seas

FastAPI MMORPG project.

## Setup

1. Create and activate virtual environment:

   `powershell
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1
   `
2. Install dependencies:

   `powershell
   pip install fastapi uvicorn sqlalchemy aiosqlite pydantic httpx
   `
3. Run server:

   `powershell
   uvicorn app.main:app --reload
   `

## Testing

`powershell
pytest -v
`

