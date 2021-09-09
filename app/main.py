from fastapi import FastAPI
from fastapi.middleware.gzip import GZipMiddleware
from fastapi.openapi.utils import get_openapi
from loguru import logger

from app.api.v1.api import api_router
from app.core import settings
from app.core.events import create_start_app_handler, create_stop_app_handler
from app.views import view_router


def create_app() -> FastAPI:
    logger.add(
        settings.LOG_FILE, level=settings.LOG_LEVEL, backtrace=settings.LOG_BACKTRACE
    )

    app = FastAPI(
        debug=settings.DEBUG,
        title=settings.PROJECT_NAME,
    )
    # add middleware
    app.add_middleware(GZipMiddleware, minimum_size=1000)

    # add event handlers
    app.add_event_handler("startup", create_start_app_handler(app))
    app.add_event_handler("shutdown", create_stop_app_handler(app))

    # add routes
    app.include_router(api_router, prefix="/api/v1")
    app.include_router(view_router)

    openapi_schema = get_openapi(
        title=settings.PROJECT_NAME,
        version=settings.VERSION,
        description=settings.DESCRIPTION,
        routes=app.routes,
    )
    app.openapi_schema = openapi_schema

    return app


app = create_app()
