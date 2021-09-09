import fakeredis.aioredis
import httpx
import pytest

from app.core.dependencies import get_redis
from app.main import create_app


async def override_get_redis():
    return await fakeredis.aioredis.create_redis_pool()


@pytest.fixture
async def client() -> httpx.AsyncClient:
    app = create_app()

    app.dependency_overrides[get_redis] = override_get_redis

    async with httpx.AsyncClient(app=app, base_url="http://testserver") as client:
        yield client
