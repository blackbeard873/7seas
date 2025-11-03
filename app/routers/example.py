from fastapi import APIRouter

router = APIRouter()

@router.get('/example')
def example():
return {'message': 'This is an example route.'}
