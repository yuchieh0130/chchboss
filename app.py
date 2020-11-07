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


def changecategory(userid, category, trackid):
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    cur = conn.cursor()

    sql = "UPDATE track SET category = %s WHERE user_id = %s, track_id = %s"
    adr = (category, userid, trackid)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()

def changeendtime(userid, date, time, trackid):
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    cur = conn.cursor()

    sql = "UPDATE track SET end_date = %s, end_time = %s WHERE user_id = %s, track_id = %s"
    adr = (date, time, userid, trackid)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()


def changestarttime(userid, date, time, trackid):
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    cur = conn.cursor()

    sql = "UPDATE track SET start_date = %s, start_time = %s WHERE user_id = %s, , track_id = %s"
    adr = (date, time, userid, trackid)
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
        # track_id = 
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
                        data='wrong'+ str(track_id)
                    )
                ]
            )
        )
        line_bot_api.reply_message(
            event.reply_token, [location_message, confirm_template_message])
    elif(event.message.text == "Contact Us"):
        line_bot_api.reply_message(event.reply_token, TextSendMessage(
            text='If you have any questions, please feel free to contact us!\nEmail chourleader@gmail.com and we will reply as soon as possible. \nThank you for your advice!'))
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
    categoryitem = ["food", 'home', 'sleep', 'lesson', 'study', 'schoolwork', 'work', 'activities', 'entertainment', 'sport',
                    'exercise', 'work out', 'leisure', 'hangout', 'dating', 'shopping', 'meeting', 'trip', 'health', 'beauty', 'commute', 'others']
    postback = event.postback.data
    user_id = event.source.user_id
    if("wrong" in postback):
        status = checkstatus(user_id)
        track_id = postback.replace("wrong", "")
        if(status == "confirmstatus"):
        buttons_template = TemplateSendMessage(
            alt_text='Buttons Template',
            template=ButtonsTemplate(
                title='Which option is incorrect?',
                text='Please select',
                actions=[
                    DatetimePickerTemplateAction(
                        label='Start time',
                        data='start_time'+str(track_id),
                        mode='datetime',
                        initial='2017-04-01t00:00',
                        min='2017-04-01t00:00',
                        max='2099-12-31t00:00'
                    ),
                    DatetimePickerTemplateAction(
                        label='End time',
                        data='end_time'+str(track_id),
                        mode='datetime',
                        initial='2017-04-01t00:00',
                        min='2017-04-01t00:00',
                        max='2099-12-31t00:00'
                    ),
                    PostbackTemplateAction(
                        label='Category',
                        text='Category',
                        data='category'+str(track_id)
                    )
                ]
            )
        )
        line_bot_api.reply_message(event.reply_token, buttons_template)
        userstatus = "wrongstatus"
        changestatus(user_id, userstatus)

        else:
            line_bot_api.reply_message(
                event.reply_token, TextSendMessage(text='你回錯啦傻逼'))
    elif(postback == "right"):
        line_bot_api.reply_message(
            event.reply_token, TextSendMessage(text=' Perfect!'))
        userstatus = "default"
        changestatus(user_id, userstatus)

    elif("start_time" in postback):
        start_time = event.postback.params
        start_date, start_time = start_time.split("T")
        status = checkstatus(user_id)
        track_id = postback.replace("start_time", "")
        if(status == "wrongstatus"):
            changestarttime(user_id, start_date, start_time, track_id)
            line_bot_api.reply_message(
                event.reply_token, TextSendMessage(text='Changed successfully!'))
            userstatus = "default"
            changestatus(user_id, userstatus)
        else:
            line_bot_api.reply_message(
                event.reply_token, TextSendMessage(text='你回錯啦傻逼'))

    elif("end_time" in postback):
        end_time = event.postback.params
        end_date, end_time = end_time.split("T")
        status = checkstatus(user_id)
        track_id = postback.replace("end_time", "")
        if(status == "wromgstatus"):
            changeendtime(user_id, end_date, end_time, track_id)
            line_bot_api.reply_message(
                event.reply_token, TextSendMessage(text='Changed successfully!'))
            userstatus = "default"
            changestatus(user_id, userstatus)
        else:
            line_bot_api.reply_message(
                event.reply_token, TextSendMessage(text='你回錯啦傻逼'))
    elif("category" in postback):
        status = checkstatus(user_id)
        track_id = postback.replace("category", "")
        if(status == "wromgstatus"):
            carousel_template_message = TemplateSendMessage(
                alt_text='Carousel template',
                template=CarouselTemplate(
                    columns=[
                        CarouselColumn(
                            thumbnail_image_url='https://upload.cc/i1/2020/10/12/HLGQzn.png',
                            title='Category',
                            text='Change your Category',
                            actions=[
                                PostbackAction(
                                    label='Food',
                                    display_text='Changed successfully!',
                                    data = "food" + str(track_id)
                                ),
                                PostbackAction(
                                    label='Home',
                                    display_text='Changed successfully!',
                                    data = "home" + str(track_id)
                                ),
                                PostbackAction(
                                    label='Sleep',
                                    display_text='Changed successfully!',
                                    data = "sleep" + str(track_id)
                                )
                            ]
                        ),
                        CarouselColumn(
                            thumbnail_image_url='https://upload.cc/i1/2020/10/12/OJdsnB.png',
                            title='Category',
                            text='Change your Category',
                            actions=[
                                PostbackAction(
                                    label='Study',
                                    display_text='Changed successfully!',
                                    data = "study"  + str(track_id)
                                ),
                                PostbackAction(
                                    label='Lesson',
                                    display_text='Changed successfully!',
                                    data = "lesson" + str(track_id)
                                ),
                                PostbackAction(
                                    label='Schoolwork',
                                    display_text='Changed successfully!',
                                    data = "schoolwork" + str(track_id)
                                )
                            ]
                        ),
                        CarouselColumn(
                            thumbnail_image_url='https://upload.cc/i1/2020/10/12/OJdsnB.png',
                            title='Category',
                            text='Change your Category',
                            actions=[
                                PostbackAction(
                                    label='Work',
                                    display_text='Changed successfully!',
                                    data = "work" + str(track_id)
                                ),
                                PostbackAction(
                                    label='Activities',
                                    display_text='Changed successfully!',
                                    data = "activities" + str(track_id)
                                ),
                                PostbackAction(
                                    label='Entertainment',
                                    display_text='Changed successfully!',
                                    data = "entertainment"  + str(track_id)
                                )
                            ]
                        ),
                        CarouselColumn(
                            thumbnail_image_url='https://upload.cc/i1/2020/10/12/OJdsnB.png',
                            title='Category',
                            text='Change your Category',
                            actions=[
                                PostbackAction(
                                    label='Sport',
                                    display_text='Changed successfully!',
                                    data = "sport" + str(track_id)
                                ),
                                PostbackAction(
                                    label='Exercise',
                                    display_text='Changed successfully!',
                                    data = "exercise" + str(track_id)
                                ),
                                PostbackAction(
                                    label='Work out',
                                    display_text='Changed successfully!',
                                    data = "work out" + str(track_id)
                                )
                            ]
                        ),
                        CarouselColumn(
                            thumbnail_image_url='https://upload.cc/i1/2020/10/12/OJdsnB.png',
                            title='Category',
                            text='Change your Category',
                            actions=[
                                PostbackAction(
                                    label='Leisure',
                                    display_text='Changed successfully!',
                                    data = "leisure" + str(track_id)
                                ),
                                PostbackAction(
                                    label='Hangout',
                                    display_text='Changed successfully!',
                                    data = "hangout" + str(track_id)
                                ),
                                PostbackAction(
                                    label='Dating',
                                    display_text='Changed successfully!',
                                    data = "dating" + str(track_id)
                                )
                            ]
                        ),
                        CarouselColumn(
                            thumbnail_image_url='https://upload.cc/i1/2020/10/12/OJdsnB.png',
                            title='Category',
                            text='Change your Category',
                            actions=[
                                PostbackAction(
                                    label='Shopping',
                                    display_text='Changed successfully!',
                                    data = "shopping" + str(track_id)
                                ),
                                PostbackAction(
                                    label='Meeting',
                                    display_text='Changed successfully!', 
                                    data = "meeting" + str(track_id)
                                ),
                                PostbackAction(
                                    label='Trip',
                                    display_text='Changed successfully!',
                                    data = "trip" + str(track_id)
                                )
                            ]
                        ),
                        CarouselColumn(
                            thumbnail_image_url='https://upload.cc/i1/2020/10/12/OJdsnB.png',
                            title='Category',
                            text='Change your Category',
                            actions=[
                                PostbackAction(
                                    label='Health',
                                    display_text='Changed successfully!',
                                    data = "health" + str(track_id)
                                ),
                                PostbackAction(
                                    label='Beauty',
                                    display_text='Changed successfully!',
                                    data = "beauty" + str(track_id)
                                ),
                                PostbackAction(
                                    label='Commute',
                                    display_text='Changed successfully!',
                                    data = "commute" + str(track_id)
                                )
                            ]
                        ),
                    ]
                )
            )
            line_bot_api.reply_message(
                event.reply_token, carousel_template_message)
            userstatus = "default"
            changestatus(user_id, userstatus)
        else:
            line_bot_api.reply_message(
                event.reply_token, TextSendMessage(text='你回錯啦傻逼'))
    elif(postback == "DAY"):
        line_bot_api.reply_message(
            event.reply_token, ImageSendMessage(original_content_url='https://upload.cc/i1/2020/10/12/ySN5UT.png', preview_image_url='https://upload.cc/i1/2020/10/12/ySN5UT.png'))
    elif any(s for s in categoryitem if s in postback):
        category = [s for s in categoryitem if s in postback][0]
        track_id = postback.replace(category, "")
        changecategory(user_id, category, track_id)
        line_bot_api.reply_message(
                event.reply_token, TextSendMessage(text='Changed sucessfully!'))

    else:
        print(88888888888)



@app.route('/')
def index():
    return 'Hello World'


if __name__ == "__main__":
    app.run()
