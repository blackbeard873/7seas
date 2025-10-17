from fastapi import FastAPI
from app.routers import auth, players, factions
from app.database import create_db_and_tables

app = FastAPI(title='7seas MMORPG')

app.include_router(auth.router)
app.include_router(players.router)
app.include_router(factions.router)

@app.on_event('startup')
async def on_startup():
    await create_db_and_tables()
