from fastapi import APIRouter
router = APIRouter(prefix='/players', tags=['players'])

@router.get('/')
async def list_players():
    return {'players': []}
