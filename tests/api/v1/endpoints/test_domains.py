import pytest
from httpx import AsyncClient


@pytest.mark.asyncio
async def test_domains(client: AsyncClient):
    res = await client.get("/api/v1/domains/")
    assert res.status_code == 200
