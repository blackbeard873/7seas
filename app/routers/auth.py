from fastapi import APIRouter

router = APIRouter()

@router.get("/status")
async def auth_status():
    return {"message": "Auth router is working!"}
