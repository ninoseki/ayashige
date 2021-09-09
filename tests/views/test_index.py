import httpx
import pytest


@pytest.mark.asyncio
async def test_index(client: httpx.AsyncClient):
    res = await client.get("/", allow_redirects=False)

    assert res.status_code == 302
    assert res.headers.get("location") == "/redoc"


@pytest.mark.asyncio
async def test_feed(client: httpx.AsyncClient):
    res = await client.get("/feed", allow_redirects=False)

    assert res.status_code == 302
    assert res.headers.get("location") == "/api/v1/domains/"
