import os

from django.core.wsgi import get_wsgi_application
from channels.routing import ProtocolTypeRouter
from channels.routing import URLRouter
from django.core.asgi import get_asgi_application
from channels.auth import AuthMiddlewareStack
from loginlogout.routing import ws_urlpatterns

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'projectapp.settings')

# application = get_wsgi_application()


application = ProtocolTypeRouter ( { 'http' : get_asgi_application()
                                    , 'websoket' : AuthMiddlewareStack(URLRouter(ws_urlpatterns))
                                    
                                    })