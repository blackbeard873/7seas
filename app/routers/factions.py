from fastapi import APIRouter

router = APIRouter(prefix="/factions", tags=["factions"])

# Mock faction data
factions = [
    {"id": 1, "name": "Crimson Corsairs", "members": 25},
    {"id": 2, "name": "Azure Raiders", "members": 32},
]

@router.get("/")
async def get_factions():
    """Return all factions."""
    return {"factions": factions}

@router.get("/{faction_id}")
async def get_faction(faction_id: int):
    """Return a single faction by ID."""
    for faction in factions:
        if faction["id"] == faction_id:
            return faction
    return {"error": "Faction not found"}
