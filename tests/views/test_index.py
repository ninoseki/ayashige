import pytest
from httpx import AsyncClient


@pytest.mark.asyncio
async def test_index(client: AsyncClient):
    res = await client.get("/", follow_redirects=False)

    assert res.status_code == 302
    assert res.headers.get("location") == "/redoc"


@pytest.mark.asyncio
async def test_feed(client: AsyncClient):
    res = await client.get("/feed", follow_redirects=False)

    assert res.status_code == 302
    assert res.headers.get("location") == "/api/v1/domains/"
