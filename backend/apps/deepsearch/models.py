from django.conf import settings
from django.db import models


class SearchRun(models.Model):
    """A local retrieval run over the Documents corpus. Answer is extractive;
    final synthesis happens on-device (the backend never runs an LLM)."""

    SCOPE_CHOICES = [('local', 'Local'), ('web', 'Web')]
    DEPTH_CHOICES = [('quick', 'Quick'), ('standard', 'Standard'), ('deep', 'Deep')]
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('running', 'Running'),
        ('ready', 'Ready'),
        ('failed', 'Failed'),
    ]

    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL, related_name='search_runs',
        on_delete=models.CASCADE, null=True, blank=True,
    )
    query = models.CharField(max_length=1024)
    scope = models.CharField(max_length=8, choices=SCOPE_CHOICES, default='local')
    depth = models.CharField(max_length=8, choices=DEPTH_CHOICES, default='standard')
    status = models.CharField(max_length=8, choices=STATUS_CHOICES, default='pending')
    answer = models.TextField(blank=True)
    sources = models.JSONField(default=list)
    error = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self) -> str:
        return f'{self.query} ({self.status})'
