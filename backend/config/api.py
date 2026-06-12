"""Root django-ninja API. Mount app routers alphabetically (house rule)."""
from ninja import NinjaAPI

from apps.ai_chat.api import router as ai_chat_router

api = NinjaAPI(title='Phoenix API', version='1.0.0')

api.add_router('/ai-chat/', ai_chat_router)


@api.get('/health/', auth=None)
def health(request):
    """Public liveness probe."""
    return {'status': 'ok', 'service': 'phoenix-backend'}
