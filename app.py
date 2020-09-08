from flask import Flask, request, abort, jsonify
from linebot import (
    LineBotApi, WebhookHandler
)
from linebot.exceptions import (
    InvalidSignatureError
)
from linebot.models import *

app = Flask(__name__)

# Channel Access Token
line_bot_api = LineBotApi('s8i38ZT3i0IOjNLSK5Tsv5uhsQa5rWMR8iEo/LzXk6E01S3n6O0mKg3FjAqAoM2DCxHVIlKiFgocJUm6CO+gf3U9oTxHYdzh/Pi6njTS8KBdxsTDnRh87lh7mrsZmokskI5kRLE7wn+i6TCj0D2tjQdB04t89/1O/w1cDnyilFU=')
# Channel Secret
handler = WebhookHandler('fd75bd7b8acf53ad43072efcbd358226')
time = ""

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
        print("Invalid signature. Please check your channel access token/channel secret.")
        abort(400)

    return 'OK'

# 處理訊息
@handler.add(MessageEvent, message=TextMessage)
def handle_message(event):
    message = TextSendMessage(text=event.message.text)
    line_bot_api.reply_message(event.reply_token, message)


# 主動傳訊息
@app.route('/posttrack', methods = ["POST"])
def posttrack():
    data = request.get_data()
    user_id = ["user_id"]
    place_name = ["place_name"]
    place_adress = ["place_adress"]
    place_latitude = ["place_latitude"]
    place_longitude = ["place_longitude"]

    location_message = LocationSendMessage(
    title=place_name,
    address=place_adress,
    latitude=place_latitude,
    longitude=place_longitude
)

    confirm_template_message = TemplateSendMessage(
    alt_text='Confirm template',
    template=ConfirmTemplate(
        text='Is it correct?',
        actions=[
            PostbackAction(
                label='right',
                display_text='Right',
                data='right'
            ),
            PostbackAction(
                label='wrong',
                display_text='Wrong',
                data='wrong'
            )
        ]
    )
)
    line_bot_api.push_message(user_id, location_message)
    line_bot_api.push_message(user_id, confirm_template_message)

@handler.add(PostbackAction)
def handler_postback(event):
    postback = event.postback.data
    if(postback == wrong):
        global time
        
        buttons_template = TemplateSendMessage(
        alt_text='Buttons Template',
        template=ButtonsTemplate(
            title='which option is wrong?',
            text='ButtonsTemplate可以傳送text,uri',
            actions=[
                DatetimePickerTemplateAction(
                        label='start time',
                        data='start_time',
                        mode='datetime',
                        initial='2017-04-01t00:00',
                        min='2017-04-01t00:00',
                        max='2099-12-31t00:00'
                    ),
                DatetimePickerTemplateAction(
                        label='end time',
                        data='end_time',
                        mode='datetime',
                        initial='2017-04-01t00:00',
                        min='2017-04-01t00:00',
                        max='2099-12-31t00:00'
                    ),
                PostbackTemplateAction(
                    label='postback',
                    text='category',
                    data='category'
                )
            ]
        )
    )
    line_bot_api.reply_message(event.reply_token, buttons_template)
    elif(postback == "right"):
        line_bot_api.reply_message(event.reply_token, TextSendMessage(text='Hello World!'))

    elif(postback == "start_time"):
        # start_time = event.postback.params
        # start_time = start_time.replace("t", " ")
        line_bot_api.reply_message(event.reply_token, TextSendMessage(text='Hello World!'))

    elif(postback == "end_time"):
        line_bot_api.reply_message(event.reply_token, TextSendMessage(text='Hello World!'))



    




# def trackReply(postback):
#     if(postback)


@app.route('/')
def index():
    return 'Hello World'

import os
if __name__ == "__main__":
    app.run()