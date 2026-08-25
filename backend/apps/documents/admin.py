from django.contrib import admin

from apps.core.admin import PhoenixModelAdmin

from .models import Document


@admin.register(Document)
class DocumentAdmin(PhoenixModelAdmin):
    list_display = ('title', 'owner', 'status', 'created_at')
    list_filter = ('status', 'created_at')
    search_fields = ('title', 'source_path')
    readonly_fields = ('created_at', 'updated_at')
    autocomplete_fields = ('owner',)
