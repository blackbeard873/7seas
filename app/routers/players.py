from fastapi import APIRouter

router = APIRouter(prefix="/players", tags=["players"])

# Mock player data
players = [
    {"id": 1, "name": "Captain Ahab", "level": 10},
    {"id": 2, "name": "Blackbeard", "level": 99},
]

@router.get("/")
async def get_players():
    """Return all players."""
    return {"players": players}

@router.get("/{player_id}")
async def get_player(player_id: int):
    """Return a single player by ID."""
    for player in players:
        if player["id"] == player_id:
            return player
    return {"error": "Player not found"}
