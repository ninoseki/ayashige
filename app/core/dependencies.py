from collections.abc import AsyncGenerator
from contextlib import asynccontextmanager

from redis.asyncio import Redis

from app.core import settings


@asynccontextmanager
async def get_redis_with_context() -> AsyncGenerator[Redis, None]:
    redis: Redis | None = None

    try:
        redis = await Redis.from_url(str(settings.REDIS_URL))
        yield redis
    finally:
        if redis is not None:
            await redis.close()


async def get_redis():
    async with get_redis_with_context() as redis:
        yield redis
