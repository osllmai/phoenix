from django.conf import settings
from django.db import models


class Extension(models.Model):
    """A marketplace feature extension users can browse and install."""

    CATEGORY_CHOICES = [
        ('document', 'Document'),
        ('speech', 'Speech'),
        ('search', 'Search'),
        ('developer', 'Developer'),
        ('evaluator', 'Evaluator'),
        ('flows', 'Flows'),
    ]

    slug = models.SlugField(max_length=128, unique=True)
    name = models.CharField(max_length=255)
    publisher = models.CharField(max_length=255)
    category = models.CharField(max_length=16, choices=CATEGORY_CHOICES)
    description = models.TextField(blank=True)
    icon = models.CharField(max_length=64, blank=True)
    version = models.CharField(max_length=32, default='1.0.0')
    verified = models.BooleanField(default=False)
    rating = models.FloatField(default=0)
    installs_count = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['name']

    def __str__(self) -> str:
        return f'{self.name} ({self.category})'


class ExtensionInstall(models.Model):
    """One user's install of one extension — install state is per-account, never
    a flag on the shared catalog row."""

    extension = models.ForeignKey(Extension, related_name='installs', on_delete=models.CASCADE)
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL, related_name='extension_installs', on_delete=models.CASCADE
    )
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['extension', 'user'], name='uniq_install_per_user'),
        ]

    def __str__(self) -> str:
        return f'{self.user_id}:{self.extension_id}'
