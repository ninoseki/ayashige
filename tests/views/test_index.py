from fastapi.testclient import TestClient


def test_index(client: TestClient):
    res = client.get("/", allow_redirects=False)

    assert res.status_code == 302
    assert res.headers.get("location") == "/redoc"


def test_feed(client: TestClient):
    res = client.get("/feed", allow_redirects=False)

    assert res.status_code == 302
    assert res.headers.get("location") == "/api/v1/domains/"
