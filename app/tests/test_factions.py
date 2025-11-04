from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_get_factions():
    response = client.get("/factions/")
    assert response.status_code == 200
    data = response.json()
    assert "factions" in data
    assert isinstance(data["factions"], list)

def test_get_faction_by_id():
    response = client.get("/factions/1")
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "Crimson Corsairs"
