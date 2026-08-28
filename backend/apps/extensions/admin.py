from django.contrib import admin

from apps.core.admin import PhoenixModelAdmin

from .models import Extension, ExtensionInstall


@admin.register(Extension)
class ExtensionAdmin(PhoenixModelAdmin):
    list_display = ('name', 'slug', 'category', 'publisher', 'verified', 'installs_count')
    list_filter = ('category', 'verified')
    search_fields = ('name', 'slug', 'publisher')
    readonly_fields = ('created_at',)


@admin.register(ExtensionInstall)
class ExtensionInstallAdmin(PhoenixModelAdmin):
    list_display = ('extension', 'user', 'created_at')
    list_filter = ('created_at',)
    readonly_fields = ('created_at',)
    autocomplete_fields = ('extension', 'user')
