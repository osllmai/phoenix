from django.contrib import admin
from django.urls import include, path

from .api import api

urlpatterns = [
    path('admin/', admin.site.urls),
    # allauth headless — identity surface (signup/login/verify/reset/MFA) at
    # /_allauth/app/v1/... — keeps our own auth surface compact.
    path('_allauth/', include('allauth.headless.urls')),
    path('api/v1/', api.urls),
]
