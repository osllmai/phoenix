"""Extensions router. Marketplace catalog browse + install/uninstall."""
from datetime import datetime

from django.db.models import F, Q
from django.shortcuts import get_object_or_404
from ninja import Router, Schema

from .models import Extension

router = Router(tags=['extensions'])


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


@router.get('/', response=list[ExtensionListOut], auth=None)
def list_extensions(request, category: str | None = None, q: str | None = None):
    qs = Extension.objects.all()
    if category:
        qs = qs.filter(category=category)
    if q:
        qs = qs.filter(Q(name__icontains=q) | Q(description__icontains=q))
    return list(qs)


@router.get('/{slug}/', response=ExtensionDetailOut, auth=None)
def get_extension(request, slug: str):
    return get_object_or_404(Extension, slug=slug)


@router.post('/{slug}/install/', response=ExtensionDetailOut, auth=None)
def install_extension(request, slug: str):
    ext = get_object_or_404(Extension, slug=slug)
    Extension.objects.filter(pk=ext.pk).update(
        installed=True, installs_count=F('installs_count') + 1
    )
    ext.refresh_from_db()
    return ext


@router.post('/{slug}/uninstall/', response=ExtensionDetailOut, auth=None)
def uninstall_extension(request, slug: str):
    ext = get_object_or_404(Extension, slug=slug)
    ext.installed = False
    ext.save(update_fields=['installed'])
    return ext
