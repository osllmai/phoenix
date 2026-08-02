import pytest

pytestmark = pytest.mark.django_db


def test_me_requires_auth(client):
    assert client.get("/me/").status_code == 401


def test_garbage_token_rejected(client):
    resp = client.get("/me/", headers={"X-Session-Token": "not-a-real-token"})
    assert resp.status_code == 401


def test_get_me(client, user, token):
    resp = client.get("/me/", headers={"X-Session-Token": token})
    assert resp.status_code == 200
    assert resp.json()["email"] == "me@phoenix.test"


def test_patch_me(client, user, token):
    resp = client.patch("/me/", json={"full_name": "Phoenix User"}, headers={"X-Session-Token": token})
    assert resp.status_code == 200
    user.refresh_from_db()
    assert user.full_name == "Phoenix User"


def test_export_me(client, user, token):
    resp = client.post("/me/export/", headers={"X-Session-Token": token})
    assert resp.status_code == 200
    assert resp.json()["user"]["email"] == "me@phoenix.test"


def test_delete_me_soft_deletes(client, user, token):
    resp = client.delete("/me/", headers={"X-Session-Token": token})
    assert resp.status_code == 200
    user.refresh_from_db()
    assert user.is_active is False
    assert user.deleted_at is not None
