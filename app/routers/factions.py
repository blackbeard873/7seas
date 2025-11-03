from fastapi import APIRouter

router = APIRouter()

@router.get("/")
def list_factions():
    return [{"id": 1, "name": "The Black Pearl Crew"}]
