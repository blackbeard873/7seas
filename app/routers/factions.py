from fastapi import APIRouter
router = APIRouter(prefix='/factions', tags=['factions'])

@router.get('/')
async def list_factions():
    return {'factions': []}
