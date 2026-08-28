from django.contrib import admin

from apps.core.admin import PhoenixModelAdmin

from .models import SearchRun


@admin.register(SearchRun)
class SearchRunAdmin(PhoenixModelAdmin):
    list_display = ('query', 'owner', 'scope', 'depth', 'status', 'created_at')
    list_filter = ('status', 'scope', 'depth')
    search_fields = ('query',)
    readonly_fields = ('created_at',)
    autocomplete_fields = ('owner',)
