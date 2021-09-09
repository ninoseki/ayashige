from contextlib import asynccontextmanager
from typing import AsyncGenerator, Optional

import aioredis
import arq

from app.core import settings


def get_redis_settings() -> arq.connections.RedisSettings:
    return arq.connections.RedisSettings(
        host=settings.REDIS_URL.hostname or "localhost",
        port=settings.REDIS_URL.port or 6379,
        password=settings.REDIS_URL.password,
    )


@asynccontextmanager
async def get_redis_with_context() -> AsyncGenerator[aioredis.Redis, None]:
    redis: Optional[aioredis.Redis] = None

    try:
        redis = await aioredis.create_redis_pool(str(settings.REDIS_URL))
        yield redis
    finally:
        if redis is not None:
            redis.close()
            await redis.wait_closed()


async def get_redis():
    async with get_redis_with_context() as redis:
        yield redis
