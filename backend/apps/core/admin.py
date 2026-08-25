"""The one admin base every Phoenix ModelAdmin inherits.

Centralising it here means a change to admin behaviour (theme, permissions,
export) lands in one place rather than per-app.
"""
from unfold.admin import ModelAdmin


class PhoenixModelAdmin(ModelAdmin):
    list_per_page = 50
    save_on_top = True
