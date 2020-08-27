from flask import Flask, request, abort

from linebot import (
    LineBotApi, WebhookHandler
)
from linebot.exceptions import (
    InvalidSignatureError
)
from linebot.models import *

app = Flask(__name__)

# Channel Access Token
line_bot_api = LineBotApi(s8i38ZT3i0IOjNLSK5Tsv5uhsQa5rWMR8iEo/LzXk6E01S3n6O0mKg3FjAqAoM2DCxHVIlKiFgocJUm6CO+gf3U9oTxHYdzh/Pi6njTS8KBdxsTDnRh87lh7mrsZmokskI5kRLE7wn+i6TCj0D2tjQdB04t89/1O/w1cDnyilFU=)
# Channel Secret
handler = WebhookHandler(fd75bd7b8acf53ad43072efcbd358226)

# 監聽所有來自 /callback 的 Post Request
@app.route("/callback", methods=['POST'])
def callback():
    # get X-Line-Signature header value
    signature = request.headers['X-Line-Signature']
    # get request body as text
    body = request.get_data(as_text=True)
    app.logger.info("Request body: " + body)
    # handle webhook body
    try:
        handler.handle(body, signature)
    except InvalidSignatureError:
        abort(400)
    return 'OK'

# 處理訊息
@handler.add(MessageEvent, message=TextMessage)
def handle_message(event):
    message = TextSendMessage(text=event.message.text)
    line_bot_api.reply_message(event.reply_token, message)


@app.route('/')
def index():
    return 'Hello World'

import os
if __name__ == "__main__":
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
