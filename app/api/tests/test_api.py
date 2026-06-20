import os
import sys
from pathlib import Path

os.environ.setdefault(
    "DATABASE_URL",
    "postgresql://test:test@localhost:5432/test",
)

api_directory = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(api_directory))

from fastapi.testclient import TestClient
from main import app

client = TestClient(app)


def test_openapi_contains_entry_endpoints():
    response = client.get("/openapi.json")

    assert response.status_code == 200

    paths = response.json()["paths"]
    assert "/entries" in paths
    assert "/entries/{entry_id}" in paths