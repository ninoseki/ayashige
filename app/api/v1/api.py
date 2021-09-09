from fastapi import APIRouter

from app.api.v1.endpoints import domains

api_router = APIRouter()
api_router.include_router(domains.router, prefix="/domains", tags=["domains"])
