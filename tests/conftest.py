import asyncio

import pytest
import pytest_asyncio
from fastapi import FastAPI
from httpx import AsyncClient

from app.main import create_app


@pytest.fixture(scope="session")
def event_loop():
    loop = asyncio.get_event_loop_policy().new_event_loop()
    yield loop
    loop.close()


@pytest.fixture
def app():
    return create_app(add_event_handlers=False)


@pytest_asyncio.fixture
async def client(app: FastAPI):
    async with AsyncClient(app=app, base_url="http://test") as client:
        yield client
