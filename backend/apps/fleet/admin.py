from django.contrib import admin

from apps.core.admin import PhoenixModelAdmin

from .models import FleetEvent, FleetLane, FleetRun


class FleetLaneInline(admin.TabularInline):
    model = FleetLane
    extra = 0


class FleetEventInline(admin.TabularInline):
    model = FleetEvent
    extra = 0


@admin.register(FleetRun)
class FleetRunAdmin(PhoenixModelAdmin):
    list_display = ('prompt', 'owner', 'base_branch', 'status', 'race_mode', 'created_at')
    list_filter = ('status', 'race_mode')
    search_fields = ('prompt', 'base_branch')
    readonly_fields = ('created_at',)
    autocomplete_fields = ('owner',)
    inlines = (FleetLaneInline, FleetEventInline)
