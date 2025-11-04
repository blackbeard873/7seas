from fastapi import FastAPI
from app.routers import example, players, factions

app = FastAPI(title="7seas MMORPG API")

# Include routers
app.include_router(example.router)
app.include_router(players.router)
app.include_router(factions.router)


@app.get("/")
async def root():
    return {"message": "Welcome to 7seas!"}
