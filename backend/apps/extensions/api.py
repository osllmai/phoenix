"""Extensions router. Marketplace catalog browse + per-account install/uninstall."""
from datetime import datetime

from django.db import transaction
from django.db.models import BooleanField, Exists, F, OuterRef, Q, Value
from django.shortcuts import get_object_or_404
from ninja import Router, Schema

from apps.accounts.auth import optional_session_token_auth, session_token_auth

from .models import Extension, ExtensionInstall

router = Router(tags=['extensions'], auth=session_token_auth)


class ExtensionListOut(Schema):
    id: int
    slug: str
    name: str
    publisher: str
    category: str
    icon: str
    version: str
    verified: bool
    rating: float
    installs_count: int
    installed: bool


class ExtensionDetailOut(Schema):
    id: int
    slug: str
    name: str
    publisher: str
    category: str
    description: str
    icon: str
    version: str
    verified: bool
    rating: float
    installs_count: int
    installed: bool
    created_at: datetime


def _catalog(request):
    """The catalog with `installed` resolved for the caller — False when anonymous."""
    user = getattr(request, 'auth', None)
    if user is None or not user.is_authenticated:
        return Extension.objects.annotate(
            installed=Value(False, output_field=BooleanField())
        )
    return Extension.objects.annotate(
        installed=Exists(ExtensionInstall.objects.filter(extension=OuterRef('pk'), user=user))
    )


@router.get('/', response=list[ExtensionListOut], auth=optional_session_token_auth)
def list_extensions(request, category: str | None = None, q: str | None = None):
    qs = _catalog(request)
    if category:
        qs = qs.filter(category=category)
    if q:
        qs = qs.filter(Q(name__icontains=q) | Q(description__icontains=q))
    return list(qs)


@router.get('/{slug}/', response=ExtensionDetailOut, auth=optional_session_token_auth)
def get_extension(request, slug: str):
    return get_object_or_404(_catalog(request), slug=slug)


@router.post('/{slug}/install/', response=ExtensionDetailOut)
def install_extension(request, slug: str):
    ext = get_object_or_404(Extension, slug=slug)
    with transaction.atomic():
        _, created = ExtensionInstall.objects.get_or_create(extension=ext, user=request.auth)
        if created:
            Extension.objects.filter(pk=ext.pk).update(installs_count=F('installs_count') + 1)
    return get_object_or_404(_catalog(request), pk=ext.pk)


@router.post('/{slug}/uninstall/', response=ExtensionDetailOut)
def uninstall_extension(request, slug: str):
    ext = get_object_or_404(Extension, slug=slug)
    with transaction.atomic():
        removed, _ = ExtensionInstall.objects.filter(extension=ext, user=request.auth).delete()
        if removed:
            Extension.objects.filter(pk=ext.pk).update(installs_count=F('installs_count') - 1)
    return get_object_or_404(_catalog(request), pk=ext.pk)
