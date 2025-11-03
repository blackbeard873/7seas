from fastapi import APIRouter

router = APIRouter()

@router.get("/")
def list_players():
    return [{"id": 1, "name": "Captain Jack"}]
