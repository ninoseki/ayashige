import asyncio

import pytest
import pytest_asyncio
from fastapi import FastAPI
from fastapi_cache import FastAPICache
from fastapi_cache.backends.inmemory import InMemoryBackend
from httpx import AsyncClient

from app.main import create_app


@pytest.fixture(scope="session")
def event_loop():
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()


@pytest.fixture
def app():
    FastAPICache.init(InMemoryBackend())

    app = create_app(add_event_handlers=False)

    yield app


@pytest_asyncio.fixture
async def client(app: FastAPI):
    async with AsyncClient(app=app, base_url="http://test") as client:
        yield client
