from fastapi.testclient import TestClient


def test_domains(client: TestClient):
    res = client.get("/api/v1/domains/")
    assert res.status_code == 200
