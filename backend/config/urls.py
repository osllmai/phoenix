from django.conf import settings
from django.contrib import admin
from django.urls import include, path, re_path
from django.views.static import serve

from .api import api

urlpatterns = [
    # ponytail: Django serves the two pinned Scalar docs assets (self-hosted, no
    # third-party CDN); move to nginx/whitenoise if backend static ever grows.
    re_path(r'^scalar/(?P<path>.*)$', serve,
            {'document_root': settings.BASE_DIR / 'static' / 'scalar'}),
    path('admin/', admin.site.urls),
    # allauth headless — identity surface (signup/login/verify/reset/MFA) at
    # /_allauth/app/v1/... — keeps our own auth surface compact.
    path('_allauth/', include('allauth.headless.urls')),
    path('api/v1/', api.urls),
]
