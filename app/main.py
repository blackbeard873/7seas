from fastapi import FastAPI
from app.routers import players, factions, auth

app = FastAPI(title="7seas MMORPG")

# Include routers
app.include_router(players.router, prefix="/players", tags=["Players"])
app.include_router(factions.router, prefix="/factions", tags=["Factions"])
app.include_router(auth.router, prefix="/auth", tags=["Auth"])

@app.get("/")
def root():
    return {"message": "Welcome to 7seas MMORPG API!"}
