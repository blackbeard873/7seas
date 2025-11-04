from fastapi import APIRouter

router = APIRouter(prefix="/example", tags=["example"])

@router.get("/status")
async def get_status():
    return {"status": "example route working"}
