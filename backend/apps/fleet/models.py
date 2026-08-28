from django.conf import settings
from django.db import models


class FleetRun(models.Model):
    """One fan-out: a single prompt raced across N agents, each in its own
    isolated git worktree on the desktop runtime. Persistence only — the
    sandboxed worktree/PTY executor lives outside Django (see design/future)."""

    STATUS_CHOICES = [
        ('running', 'Running'),
        ('done', 'Done'),
        ('failed', 'Failed'),
        ('merged', 'Merged'),
    ]

    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL, related_name='fleet_runs',
        on_delete=models.CASCADE, null=True, blank=True,
    )
    prompt = models.CharField(max_length=500)
    base_branch = models.CharField(max_length=200, default='app/developer')
    race_mode = models.BooleanField(default=True)
    status = models.CharField(max_length=16, choices=STATUS_CHOICES, default='running')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self) -> str:
        return f'{self.prompt[:40]} ({self.status})'


class FleetLane(models.Model):
    """One agent's lane within a run: its worktree, live state, and diff stats."""

    STATE_CHOICES = [
        ('queued', 'Queued'),
        ('running', 'Running'),
        ('done', 'Done'),
        ('blocked', 'Blocked'),
        ('failed', 'Failed'),
    ]
    ROUTE_CHOICES = [('local', 'Local'), ('cloud', 'Cloud'), ('denied', 'Denied')]

    run = models.ForeignKey(FleetRun, related_name='lanes', on_delete=models.CASCADE)
    agent = models.CharField(max_length=64)
    role = models.CharField(max_length=64, blank=True)
    worktree_path = models.CharField(max_length=200)
    state = models.CharField(max_length=16, choices=STATE_CHOICES, default='queued')
    status_label = models.CharField(max_length=32, default='queued')
    summary = models.TextField(blank=True)
    additions = models.IntegerField(default=0)
    deletions = models.IntegerField(default=0)
    files_changed = models.IntegerField(default=0)
    elapsed = models.CharField(max_length=16, blank=True)
    route = models.CharField(max_length=8, choices=ROUTE_CHOICES, default='local')
    cost = models.CharField(max_length=16, blank=True)
    is_winner = models.BooleanField(default=False)

    class Meta:
        ordering = ['id']

    def __str__(self) -> str:
        return f'{self.agent}@{self.worktree_path}'


class FleetEvent(models.Model):
    """A line in the run's event log (actor → outcome · text)."""

    run = models.ForeignKey(FleetRun, related_name='events', on_delete=models.CASCADE)
    at = models.CharField(max_length=16)
    actor = models.CharField(max_length=64)
    text = models.CharField(max_length=255)
    outcome = models.CharField(max_length=128, blank=True)

    class Meta:
        ordering = ['id']

    def __str__(self) -> str:
        return f'{self.at} {self.actor}'
