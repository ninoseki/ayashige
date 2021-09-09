from fastapi import APIRouter

from . import index

view_router = APIRouter()
view_router.include_router(index.router)
