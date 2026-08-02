from django.db import migrations

SEED = [
    {'slug': 'docling-convert', 'name': 'Docling Convert', 'publisher': 'Phoenix',
     'category': 'document', 'description': 'Convert PDFs and office files to clean markdown.',
     'icon': '📄', 'verified': True, 'rating': 4.8, 'installs_count': 12000},
    {'slug': 'whisper-speech', 'name': 'Whisper Speech', 'publisher': 'Phoenix',
     'category': 'speech', 'description': 'On-device speech-to-text transcription.',
     'icon': '🎙️', 'verified': True, 'rating': 4.6, 'installs_count': 8200},
    {'slug': 'local-search', 'name': 'Local Search', 'publisher': 'Phoenix',
     'category': 'search', 'description': 'Semantic search across your local documents.',
     'icon': '🔎', 'verified': True, 'rating': 4.5, 'installs_count': 6400},
    {'slug': 'agentic-cli', 'name': 'Agentic CLI', 'publisher': 'Phoenix',
     'category': 'developer', 'description': 'Run agentic coding CLIs against the local gateway.',
     'icon': '🛠️', 'verified': True, 'rating': 4.7, 'installs_count': 5100},
    {'slug': 'model-evaluator', 'name': 'Model Evaluator', 'publisher': 'Phoenix',
     'category': 'evaluator', 'description': 'Benchmark and score local models on your prompts.',
     'icon': '📊', 'verified': False, 'rating': 4.2, 'installs_count': 2300},
    {'slug': 'flow-builder', 'name': 'Flow Builder', 'publisher': 'Phoenix',
     'category': 'flows', 'description': 'Compose multi-step LLM workflows visually.',
     'icon': '🔀', 'verified': False, 'rating': 4.3, 'installs_count': 3100},
]


def seed(apps, schema_editor):
    Extension = apps.get_model('extensions', 'Extension')
    for row in SEED:
        Extension.objects.get_or_create(slug=row['slug'], defaults=row)


def unseed(apps, schema_editor):
    Extension = apps.get_model('extensions', 'Extension')
    Extension.objects.filter(slug__in=[r['slug'] for r in SEED]).delete()


class Migration(migrations.Migration):

    dependencies = [
        ('extensions', '0001_initial'),
    ]

    operations = [
        migrations.RunPython(seed, unseed),
    ]
