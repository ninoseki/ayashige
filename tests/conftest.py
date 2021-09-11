import fakeredis.aioredis
import pytest
from fastapi.testclient import TestClient

from app.core.dependencies import get_redis
from app.main import create_app


async def override_get_redis():
    return await fakeredis.aioredis.create_redis_pool()


@pytest.fixture
def client() -> TestClient:
    app = create_app()

    app.dependency_overrides[get_redis] = override_get_redis

    with TestClient(
        app=app,
        base_url="http://testserver",
    ) as c:
        yield c
