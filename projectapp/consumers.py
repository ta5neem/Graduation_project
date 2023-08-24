
import json
from channels.generic.websocket import AsyncWebsocketConsumer
from asgiref.sync import async_to_sync

class ContinuousProcessingConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        await self.accept()

    async def disconnect(self, close_code):
        pass

    async def send_message(self, message):
        await self.send(text_data=json.dumps({"message": message}))