"""Root django-ninja API. Mount app routers alphabetically (house rule)."""
from ninja import NinjaAPI

from apps.accounts.api import router as accounts_router
from apps.ai_chat.api import router as ai_chat_router
from apps.deepsearch.api import router as deepsearch_router
from apps.documents.api import router as documents_router
from apps.extensions.api import router as extensions_router
from apps.fleet.api import router as fleet_router

from .scalar import docs_viewer

api = NinjaAPI(title='Phoenix API', version='1.0.0', docs=docs_viewer)

api.add_router('/accounts/', accounts_router)
api.add_router('/ai-chat/', ai_chat_router)
api.add_router('/deepsearch/', deepsearch_router)
api.add_router('/documents/', documents_router)
api.add_router('/extensions/', extensions_router)
api.add_router('/fleet/', fleet_router)


@api.get('/health/', auth=None)
def health(request):
    """Public liveness probe."""
    return {'status': 'ok', 'service': 'phoenix-backend'}
