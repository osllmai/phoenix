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


def test_patch_me_rejects_oversized_fields(client, user, token):
    resp = client.patch(
        "/me/",
        json={"full_name": "sweep" * 100, "locale": "sweep" * 100},
        headers={"X-Session-Token": token},
    )
    assert resp.status_code == 422


def test_patch_me_ignores_explicit_nulls(client, user, token):
    resp = client.patch(
        "/me/",
        json={"full_name": None, "locale": None},
        headers={"X-Session-Token": token},
    )
    assert resp.status_code == 200
    user.refresh_from_db()
    assert user.locale == "en"


def test_create_superuser_sets_staff_and_superuser():
    from apps.accounts.models import User

    su = User.objects.create_superuser("root@phoenix.test", "pw-long-enough-123")
    assert su.is_staff and su.is_superuser
    assert su.check_password("pw-long-enough-123")


def test_create_user_requires_email():
    from apps.accounts.models import User

    with pytest.raises(ValueError, match="Email is required"):
        User.objects.create_user("", "pw-long-enough-123")
