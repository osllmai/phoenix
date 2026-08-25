from django.conf import settings
from django.db import models


class Document(models.Model):
    """A source file converted to markdown via an async Celery job.

    `owner` is nullable so the column could be added without dropping rows, but
    every query filters on it — an unowned row is reachable by nobody.
    """

    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('converting', 'Converting'),
        ('ready', 'Ready'),
        ('failed', 'Failed'),
    ]

    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL, related_name='documents',
        on_delete=models.CASCADE, null=True, blank=True,
    )
    title = models.CharField(max_length=255)
    source_path = models.CharField(max_length=1024)
    status = models.CharField(max_length=16, choices=STATUS_CHOICES, default='pending')
    markdown = models.TextField(blank=True)
    error = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self) -> str:
        return f'{self.title} ({self.status})'
