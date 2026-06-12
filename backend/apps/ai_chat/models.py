from django.db import models


class ChatJob(models.Model):
    """Tracks a long-running async job (deep-search, embeddings) for a request."""

    KIND_CHOICES = [('deep_search', 'Deep Search'), ('embeddings', 'Embeddings')]

    celery_id = models.CharField(max_length=255, unique=True)
    kind = models.CharField(max_length=32, choices=KIND_CHOICES)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self) -> str:
        return f'{self.kind}:{self.celery_id}'
