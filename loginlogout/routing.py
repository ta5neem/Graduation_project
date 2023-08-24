from django.urls import path 
import consumers
from django.urls import re_path

ws_urlpatterns = [
#    path('ws/some_urls')
    path(r'ws/continuous_processing/', consumers.ContinuousProcessingConsumer.as_asgi()),

]
from . import consumers

websocket_urlpatterns = [
    re_path(r'ws/continuous_processing/$', consumers.ContinuousProcessingConsumer.as_asgi()),
]