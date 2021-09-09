import httpx
import pytest


@pytest.mark.asyncio
async def test_domains(client: httpx.AsyncClient):
    res = await client.get("/api/v1/domains/")
    assert res.status_code == 200
