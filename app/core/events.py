from collections.abc import Coroutine
from typing import Any, Callable, Union

from fastapi import FastAPI
from fastapi_cache import FastAPICache
from fastapi_cache.backends.redis import RedisBackend
from loguru import logger
from redis import asyncio as aioredis

from app.cache.backend import InMemoryBackend
from app.core import settings


def create_start_app_handler(
    app_: FastAPI,
) -> Callable[[], Coroutine[Any, Any, None]]:
    async def start_app() -> None:
        # initialize FastAPI cache
        backend: Union[InMemoryBackend, RedisBackend] = InMemoryBackend()

        if settings.REDIS_URL != "" and settings.TESTING is False:
            try:
                redis = aioredis.from_url(str(settings.REDIS_URL))
                backend = RedisBackend(redis)
            except (ConnectionRefusedError, OSError) as e:
                logger.error("Failed to connect to Redis")
                logger.exception(e)

        FastAPICache.init(backend, prefix="fastapi-cache")

    return start_app


def create_stop_app_handler(
    app_: FastAPI,
) -> Callable[[], Coroutine[Any, Any, None]]:
    async def stop_app() -> None:
        pass

    return stop_app
