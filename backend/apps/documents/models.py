from django.db import models


class Document(models.Model):
    """A source file converted to markdown via an async Celery job."""

    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('converting', 'Converting'),
        ('ready', 'Ready'),
        ('failed', 'Failed'),
    ]

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
