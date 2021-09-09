from fastapi import APIRouter
from fastapi.responses import RedirectResponse

router = APIRouter()


@router.get("/", include_in_schema=False)
def redoc():
    return RedirectResponse("/redoc", status_code=302)


@router.get("/feed", include_in_schema=False)
def feed():
    # redirect /feed to /api/v1/domains/ to keep the backward compatibility
    return RedirectResponse("/api/v1/domains/", status_code=302)
