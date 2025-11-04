from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_get_players():
    response = client.get("/players/")
    assert response.status_code == 200
    data = response.json()
    assert "players" in data
    assert isinstance(data["players"], list)

def test_get_player_by_id():
    response = client.get("/players/2")
    assert response.status_code == 200
    data = response.json()
    assert data["name"] == "Blackbeard"
