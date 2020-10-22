import os
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
line_bot_api = LineBotApi(
    's8i38ZT3i0IOjNLSK5Tsv5uhsQa5rWMR8iEo/LzXk6E01S3n6O0mKg3FjAqAoM2DCxHVIlKiFgocJUm6CO+gf3U9oTxHYdzh/Pi6njTS8KBdxsTDnRh87lh7mrsZmokskI5kRLE7wn+i6TCj0D2tjQdB04t89/1O/w1cDnyilFU=')
# Channel Secret
handler = WebhookHandler('fd75bd7b8acf53ad43072efcbd358226')

def changestarttime(userid, date, time):
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    cur = conn.cursor()

    sql = "UPDATE track SET start_date = %s, start_time = %s WHERE user_id = %s"
    adr = (date, time, userid)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()

def changeendtime(userid, date, time):
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    cur = conn.cursor()

    sql = "UPDATE track SET end_date = %s, end_time = %s WHERE user_id = %s"
    adr = (date, time, userid)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()

def changestarttime(userid, date, time):
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    cur = conn.cursor()

    sql = "UPDATE track SET start_date = %s, start_time = %s WHERE user_id = %s"
    adr = (date, time, userid)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()
    
def checkstatus(userid):
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    cur = conn.cursor()

    sql = "SELECT status FROM userstatus Where user_id = %s"
    adr = (userid, )
    cur.execute(sql, adr)
    fetch_data = cur.fetchall()
    user_status = fetch_data[0][0]
    cur.close()
    return user_status

def changestatus(userid, userstatus):
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    cur = conn.cursor()

    sql = "UPDATE userstatus SET status = %s WHERE user_id = %s"
    adr = (userstatus, userid)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()


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
    user_id = event.source.user_id
    if(event.message.text == "Analysis!"):
        buttons_template = TemplateSendMessage(
            alt_text='Buttons Template',
            template=ButtonsTemplate(
                title='Analysis',
                text='Choose the period of Analysis report you would like to see.',
                thumbnail_image_url='https://upload.cc/i1/2020/10/12/OJdsnB.png',
                actions=[
                    PostbackTemplateAction(
                        label='DAY',
                        text='DAY',
                        data='DAY'
                    ),
                    PostbackTemplateAction(
                        label='WEEK',
                        text='WEEK',
                        data='WEEK'
                    ),
                    PostbackTemplateAction(
                        label='MONTH',
                        text='MONTH',
                        data='MONTH'
                    )
                ]
            )
        )
        line_bot_api.reply_message(event.reply_token, buttons_template)
    elif(event.message.text == "嗨"):
        location_message = LocationSendMessage(
            title="Study",
            address="10/6 18:00~20:00",
            latitude=24.986893,
            longitude=121.577033
        )
        confirm_template_message = TemplateSendMessage(
            alt_text='Confirm template',
            template=ConfirmTemplate(
                text='Is it correct?',
                actions=[
                    PostbackAction(
                        label='Right',
                        display_text='Right',
                        data='right'
                    ),
                    PostbackAction(
                        label='Wrong',
                        display_text='Wrong',
                        data='wrong'
                    )
                ]
            )
        )
        line_bot_api.reply_message(
            event.reply_token, [location_message, confirm_template_message])
    elif(event.message.text == "Contact Us"):
        line_bot_api.reply_message(event.reply_token, TextSendMessage(text='If you have any questions, please feel free to contact us!\nEmail chourleader@gmail.com and we will reply as soon as possible. \nThank you for your advice!'))
    else:
        return True


# 主動傳訊息
# @app.route('/posttrack', methods=["POST"])
# def posttrack():
#     data = request.get_data()
#     user_id = ["user_id"]
#     place_name = ["place_name"]
#     place_adress = ["place_adress"]
#     place_latitude = ["place_latitude"]
#     place_longitude = ["place_longitude"]

#     # location_message = LocationSendMessage(
#     # title=place_name,
#     # address=place_adress,
#     # latitude=place_latitude,
#     # longitude=place_longitude
#     location_message = LocationSendMessage(
#         title="Study",
#         address="10/6 18:00~20:00",
#         latitude=place_latitude,
#         longitude=place_longitude
#     )

#     confirm_template_message = TemplateSendMessage(
#         alt_text='Confirm template',
#         template=ConfirmTemplate(
#             text='Is it correct?',
#             actions=[
#                 PostbackAction(
#                     label='right',
#                     display_text='Right',
#                     data='right'
#                 ),
#                 PostbackAction(
#                     label='wrong',
#                     display_text='Wrong',
#                     data='wrong'
#                 )
#             ]
#         )
#     )
#     line_bot_api.push_message(user_id, location_message)
#     line_bot_api.push_message(user_id, confirm_template_message)


@handler.add(PostbackEvent)
def handler_postback(event):
    postback = event.postback.data
    user_id = event.source.user_id
    if(postback == "wrong"):
        status = checkstatus(user_id)
        if(status ==  "confirmstatus"):
        buttons_template = TemplateSendMessage(
            alt_text='Buttons Template',
            template=ButtonsTemplate(
                title='Which option is incorrect?',
                text='Please select',
                actions=[
                    DatetimePickerTemplateAction(
                        label='Start time',
                        data='start_time',
                        mode='datetime',
                        initial='2017-04-01t00:00',
                        min='2017-04-01t00:00',
                        max='2099-12-31t00:00'
                    ),
                    DatetimePickerTemplateAction(
                        label='End time',
                        data='end_time',
                        mode='datetime',
                        initial='2017-04-01t00:00',
                        min='2017-04-01t00:00',
                        max='2099-12-31t00:00'
                    ),
                    PostbackTemplateAction(
                        label='Category',
                        text='Category',
                        data='category'
                    )
                ]
            )
        )
        line_bot_api.reply_message(event.reply_token, buttons_template)
        userstatus = "wrongstatus"
        changestatus(user_id, userstatus)

        else:
            line_bot_api.reply_message(event.reply_token, TextSendMessage(text=''))
    elif(postback == "right"):
        line_bot_api.reply_message(
            event.reply_token, TextSendMessage(text=' Perfect!'))
        userstatus = "default"
        changestatus(user_id, userstatus)
        
    elif(postback == "start_time"):
        start_time = event.postback.params
        start_date, start_time = start_time.split("T")
        status = checkstatus(user_id)
        if(status == "wrongstatus"):
            changestarttime(user_id, start_date, start_time)
            line_bot_api.reply_message(
                event.reply_token, TextSendMessage(text='Changed successfully!'))
            userstatus = "default"
            changestatus(user_id, userstatus)
        else:
            line_bot_api.reply_message(event.reply_token, TextSendMessage(text=''))
    
    elif(postback == "end_time"):
        end_time = event.postback.params
        end_date, end_time = end_time.split("T")
        status = checkstatus(user_id)
        if(status == "wromgstatus"):
            changeendtime(user_id, end_date, end_time)
            line_bot_api.reply_message(
                event.reply_token, TextSendMessage(text='Changed successfully!'))
            userstatus = "default"
            changestatus(user_id, userstatus)
        else:
            line_bot_api.reply_message(event.reply_token, TextSendMessage(text=''))
    elif(postback == "category"):
        status = checkstatus(user_id)
        if(status ==  
        carousel_template_message = TemplateSendMessage(
            alt_text='Carousel template',
            template=CarouselTemplate(
                columns=[
                    CarouselColumn(
                        thumbnail_image_url='https://upload.cc/i1/2020/10/12/HLGQzn.png',
                        title='Category',
                        text='Change your Category',
                        actions=[
                            MessageAction(
                                label='Food',
                                text='Changed successfully!',
                            ),
                            MessageAction(
                                label='Home',
                                text='Changed successfully!'
                            ),
                            MessageAction(
                                label='Sleep',
                                text='Changed successfully!'
                            )
                        ]
                    ),
                    CarouselColumn(
                        thumbnail_image_url='https://upload.cc/i1/2020/10/12/OJdsnB.png',
                        title='Category',
                        text='Change your Category',
                        actions=[
                            MessageAction(
                                label='Study',
                                text='Changed successfully!',
                            ),
                            MessageAction(
                                label='Lesson',
                                text='Changed successfully!'
                            ),
                            MessageAction(
                                label='Schoolwork',
                                text='Changed successfully!'
                            )
                        ]
                    ),
                    CarouselColumn(
                        thumbnail_image_url='https://upload.cc/i1/2020/10/12/OJdsnB.png',
                        title='Category',
                        text='Change your Category',
                        actions=[
                            MessageAction(
                                label='Work',
                                text='Changed successfully!',
                            ),
                            MessageAction(
                                label='Activities',
                                text='Changed successfully!'
                            ),
                            MessageAction(
                                label='Study',
                                text='Changed successfully!'
                            )
                        ]
                    ),
                    CarouselColumn(
                        thumbnail_image_url='https://upload.cc/i1/2020/10/12/OJdsnB.png',
                        title='Category',
                        text='Change your Category',
                        actions=[
                            MessageAction(
                                label='Sport',
                                text='Changed successfully!',
                            ),
                            MessageAction(
                                label='Exercise',
                                text='Changed successfully!'
                            ),
                            MessageAction(
                                label='Work out',
                                text='Changed successfully!'
                            )
                        ]
                    ),
                    CarouselColumn(
                        thumbnail_image_url='https://upload.cc/i1/2020/10/12/OJdsnB.png',
                        title='Category',
                        text='Change your Category',
                        actions=[
                            MessageAction(
                                label='Leisure',
                                text='Changed successfully!',
                            ),
                            MessageAction(
                                label='Hangout',
                                text='Changed successfully!'
                            ),
                            MessageAction(
                                label='Dating',
                                text='Changed successfully!'
                            )
                        ]
                    ),
                    CarouselColumn(
                        thumbnail_image_url='https://upload.cc/i1/2020/10/12/OJdsnB.png',
                        title='Category',
                        text='Change your Category',
                        actions=[
                            MessageAction(
                                label='Shopping',
                                text='Changed successfully!',
                            ),
                            MessageAction(
                                label='Meeting',
                                text='Changed successfully!'
                            ),
                            MessageAction(
                                label='Trip',
                                text='Changed successfully!'
                            )
                        ]
                    ),
                    CarouselColumn(
                        thumbnail_image_url='https://upload.cc/i1/2020/10/12/OJdsnB.png',
                        title='Category',
                        text='Change your Category',
                        actions=[
                            MessageAction(
                                label='Health',
                                text='Changed successfully!',
                            ),
                            MessageAction(
                                label='Beauty',
                                text='Changed successfully!'
                            ),
                            MessageAction(
                                label='Commute',
                                text='Changed successfully!'
                            )
                        ]
                    ),
                ]
            )
        )
        line_bot_api.reply_message(event.reply_token, carousel_template_message)
    elif(postback == "DAY"):
        line_bot_api.reply_message(
            event.reply_token, ImageSendMessage(original_content_url='https://upload.cc/i1/2020/10/12/ySN5UT.png', preview_image_url='https://upload.cc/i1/2020/10/12/ySN5UT.png'))
    else:
        print(88888888888)


# def trackReply(postback):
#     if(postback)


@app.route('/')
def index():
    return 'Hello World'


if __name__ == "__main__":
    app.run()
