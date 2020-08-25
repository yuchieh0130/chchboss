from flask import Flask, jsonify, request
from flask_mysqldb import MySQL
import mysql.connector
import uuid
app = Flask(__name__)


conn = mysql.connector.Connect(
    host='localhost', user='root', password='chchboss', database='mo')

# app.config["MYSQL_HOST"] = "127.0.0.1"
# app.config["MYSQL_USER"] = "root"
# app.config["MYSQL_PASSWORD"] = "chchtest"
# app.config["MYSQL_DB"] = "appdb"


mysql = MySQL(app)


@app.route("/")
def home():
    return "Hello Flask"


@app.route("/testGet")
def test():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    cur = conn.cursor()
    cur.execute("SELECT * FROM appdb.test")
    results = cur.fetchall()
    print(results)
    cur.close()
    return jsonify(results)


@app.route("/testInsert", methods=["GET"])
def inserttest():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    cur = conn.cursor()
    sql = "INSERT INTO test (test_id, test_number, test_null) VALUES (%s, %s, %s)"
    val = ("1234567890", "12345678", "123")
    cur.execute(sql, val)
    conn.commit()
    cur.close()
    return jsonify({"status_code": 200})


@app.route("/insertLocation", methods=["POST"])
def insertLocation():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()

    longitude = data["longitude"]
    latitude = data["latitude"]
    start_date = data["start_date"]
    start_time = data["start_time"]
    duration = data["duration"]
    speed = data["speed"]
    name1 = data["name1"]
    name2 = data["name2"]
    name3 = data["name3"]
    name4 = data["name4"]
    name5 = data["name5"]
    weekday = data["weekday"]
    category1 = data["category1"]
    category2 = data["category2"]
    category3 = data["category3"]
    category4 = data["category4"]
    category5 = data["category5"]
    user_id = data["user_id"]
    user_location_id = data["user_location_id"]

    cur = conn.cursor()
    sql = "INSERT INTO location (longitude, latitude, start_date, start_time, weekday, duration, speed, name1, name2, name3, name4, name5, category1, category2, category3, category4, category5, user_id, user_location_id) VALUES ( %s, %s, %s, %s, %s, %s, %s, %s, %s,  %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
    adr = (longitude, latitude, start_date, start_time, weekday, duration, speed, name1, name2,
           name3, name4, name5, category1, category2, category3, category4, category5, user_id, user_location_id)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()
    return jsonify({"status_code": 200})


@app.route("/insertSavedplace", methods=["POST"])
def insertSavedplace():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()

    user_id = data["user_id"]
    user_place_id = data["user_place_id"]
    place_name = data["place_name"]
    place_category = data["place_category"]
    place_longitude = data["place_longitude"]
    place_latitude = data["place_latitude"]
    my_place = data["my_place"]

    cur = conn.cursor()
    sql = "INSERT INTO savedplace (user_place_id, place_name, place_category, place_longitude, place_latitude, my_place, user_id) VALUES (%s, %s, %s, %s, %s, %s, %s)"
    adr = (place_id, place_name, place_category, place_longitude,
           place_latitude, my_place, user_id)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()
    return jsonify({"status_code": 200})


@app.route("/updateSavedplace", methods=["POST"])
def updateSavedplace():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()

    user_id = data["user_id"]
    user_place_id = data["user_place_id"]
    place_name = data["place_name"]
    place_category = data["place_category"]
    place_longitude = data["place_longitude"]
    place_latitude = data["place_latitude"]
    my_place = data["my_place"]

    cur = conn.cursor()
    sql = "UPDATE savedplace SET place_name = %s, place_category = %s, place_longitude = %s, place_latitude = %s, my_place = %s WHERE user_id = %s AND user_location_id = %s"
    adr = (place_name, place_category, place_longitude, place_latitude,
           my_place, user_id, user_place_id)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()
    return jsonify({"status_code": 200})


@app.route("/deleteSavedplace", methods=["POST"])
def deleteSavedplace():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()

    user_id = data["user_id"]
    user_place_id = data["user_place_id"]

    cur = conn.cursor()
    sql = "DELETE FROM savedplace WHERE user_id = %s and user_place_id = %s"
    adr = (user_id, user_place_id)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()
    return jsonify({"status_code": 200})


# @app.route("/insertTrack", methods=["POST"])
# def insertTrack():
#     data = request.get_json()

#     track_id = data["track_id"]
#     start_date = data["start_date"]
#     start_time = data["start_time"]
#     end_date = data["end_date"]
#     end_time = data["end_time"]
#     category_id = data["category_id"]
#     location_id = data["location_id"]
#     place_id = data["place_id"]

#     user_id  = data["user_id"]

#     cur = conn.cursor()
#     sql = "INSERT INTO track (track_id, start_date, start_time, end_date, end_time, category_id, loaction_id, place_id, user_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"
#     adr = (track_id, start_date, start_time, end_date, end_time, category_id, location_id, place_id, user_id)
#     cur.execute(sql, adr)
#     conn.commit()
#     cur.close()
#     return jsonify({"status_code": 200})


@app.route("/pushTrack", methods=["POST"])
def pushTrack():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()
    last_track_id = int(data["last_track_id"])
    user_id = int(data["user_id"])

    cur = conn.cursor()
    sql = "SELECT * FROM track WHERE user_id = %s AND track_id > %s AND record = 0"
    adr = (user_id, last_track_id)
    cur.execute(sql, adr)
    fetch_data = cur.fetchall()
    track_data = fetch_data
    last_track_id = track_data[-1][0]
    cur.close()

    cur = conn.cursor()
    sql = "UPDATE track SET record = %s WHERE user_id = %s AND record = %s"
    adr = (True, user_id, False)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()

    return jsonify({"status_code": 200,
                    "data": track_data,
                    "last_track_id": last_track_id})


@app.route("/updateTrack", methods=["POST"])
def updateTrack():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()
    user_id = data["user_id"]
    new_start_date = data["new_start_date"]
    new_start_time = data["new_start_time"]
    new_weekday = data["new_weekday"]
    new_end_date = data["new_end_date"]
    new_end_time = data["new_end_time"]
    new_category_id = int(data["new_category_id"])
    new_location_id = int(data["new_location_id"])
    new_place_id = int(data["new_place_id"])

    old_start_date = data["old_start_date"]
    old_start_time = data["old_start_time"]
    old_weekday = int(data["old_weekday"])
    old_end_date = data["old_end_date"]
    old_end_time = data["old_end_time"]
    old_category_id = int(data["old_category_id"])
    old_location_id = int(data["old_location_id"])
    old_place_id = int(data["old_place_id"])

    nw_start_datetime = new_start_date + new_start_time
    od_start_datetime = old_start_date + old_start_time
    nw_end_datetime = new_end_date + new_end_time
    od_end_datetime = old_end_date + old_end_time

    if(nw_start_datetime == od_start_datetime and nw_end_datetime == od_end_datetime):
        cur = conn.cursor()
        sql = "UPDATE track SET category_id = %s, location_id = %s, place_id = %s WHERE start_time = %s and start_date = %s and user_id = %s"
        adr = (new_category_id, new_location_id, new_place_id,
               new_start_time, new_start_date, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()

    # 2-10=>5-13
    elif(nw_start_datetime > od_start_datetime and nw_end_datetime > od_end_datetime):
        cur = conn.cursor()
        sql = "DELETE FROM track WHERE CONCAT(start_date, start_time) between %s and %s AND CONCAT(end_date, end_time) between %s and %s AND user_id = %s"
        adr = (nw_start_datetime, nw_end_datetime,
               nw_start_datetime, nw_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "UPDATE track SET start_date = %s, start_time = %s, weekday = %s, end_date = %s, end_time = %s, category_id = %s, location_id = %s, place_id = %s WHERE CONCAT(start_date, start_time) = %s AND CONCAT(end_date, end_time) = %s AND user_id = %s"
        adr = (new_start_date, new_start_time, new_weekday, new_end_date, new_end_time, new_category_id,
               new_location_id, new_place_id, od_start_datetime, od_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "UPDATE track SET start_date = %s, start_time = %s, weekday = %s WHERE CONCAT(start_date, start_time) between %s and %s AND user_id = %s"
        adr = (new_end_date, new_end_time, weekday,
               nw_start_datetime, nw_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "UPDATE track SET end_date = %s, end_time = %s WHERE CONCAT(end_date, end_time) = %s AND user_id = %s"
        adr = (new_start_date, new_start_time, od_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        return jsonify({"status_code": 200})
    elif(nw_start_datetime < od_start_datetime and nw_end_datetime < od_end_datetime):
        cur = conn.cursor()
        sql = "DELETE FROM track WHERE CONCAT(start_date, start_time) between %s and %s AND CONCAT(end_date, end_time) between %s and %s AND user_id = %s"
        adr = (nw_start_datetime, nw_end_datetime,
               nw_start_datetime, nw_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "UPDATE track SET start_date = %s, start_time = %s, weekday = %s, end_date = %s, end_time = %s, category_id = %s, location_id = %s, place_id = %s WHERE CONCAT(start_date, start_time) = %s AND CONCAT(end_date, end_time) = %s AND user_id = %s"
        adr = (new_start_date, new_start_time, new_weekday, new_end_date, new_end_time, new_category_id,
               new_location_id, new_place_id, od_start_datetime, od_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "UPDATE track SET end_date = %s, end_time = %s WHERE CONCAT(end_date, end_time) between %s and %s AND user_id = %s"
        adr = (new_start_date, new_start_time,
               nw_start_datetime, nw_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        if(new_start_time > new_end_time):
            cur = conn.cursor()
            sql = "UPDATE track SET start_date = %s, start_time = %s, weekday = %s WHERE CONCAT(start_date, start_time) = %s AND user_id = %s"
            adr = (new_end_date, new_end_time,
                   new_weekday+1, od_end_datetime, user_id)
            cur.execute(sql, adr)
            conn.commit()
            cur.close()
        else:
            cur = conn.cursor()
            sql = "UPDATE track SET start_date = %s, start_time = %s WHERE CONCAT(start_date, start_time) = %s AND user_id = %s"
            adr = (new_end_date, new_end_time, od_end_datetime, user_id)
            cur.execute(sql, adr)
            conn.commit()
            cur.close()
        return jsonify({"status_code": 200})
    elif((nw_start_datetime < od_start_datetime and nw_end_datetime > od_end_datetime) or (nw_start_datetime <= od_start_datetime and nw_end_datetime > od_end_datetime) or (nw_start_datetime < od_start_datetime and nw_end_datetime >= od_end_datetime)):
        cur = conn.cursor()
        sql = "DELETE FROM track WHERE CONCAT(start_date, start_time) between %s and %s AND CONCAT(end_date, end_time) between %s and %s AND user_id = %s"
        adr = (nw_start_datetime, nw_end_datetime,
               nw_start_datetime, nw_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "INSERT INTO track(start_date, start_time, weekday, end_date, end_time, category_id, loaction_id, place_id, user_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"
        adr = (new_start_date, new_start_time, new_weekday, new_end_date, new_end_time,
               new_category_id, new_location_id, new_place_id, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "UPDATE track SET end_date = %s, end_time = %s WHERE CONCAT(end_date, end_time) between %s and %s AND user_id = %s"
        adr = (new_start_date, new_start_time,
               nw_start_datetime, nw_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        if(new_start_time > new_end_time):
            cur = conn.cursor()
            sql = "UPDATE track SET start_date = %s, start_time = %s, weekday = %s WHERE CONCAT(start_date, start_time) between %s and %s AND user_id = %s"
            adr = (new_end_date, new_end_time, new_weekday+1,
                    nw_start_datetime, nw_end_datetime, user_id)
            cur.execute(sql, adr)
            conn.commit()
            cur.close()
        else:
            cur = conn.cursor()
            sql = "UPDATE track SET start_date = %s, start_time = %s WHERE CONCAT(start_date, start_time) between %s and %s AND user_id = %s"
            adr = (new_end_date, new_end_time,
                    nw_start_datetime, nw_end_datetime, user_id)
            cur.execute(sql, adr)
            conn.commit()
            cur.close()
        return jsonify({"status_code": 200})
    elif((nw_start_datetime > od_start_datetime and nw_end_datetime < od_end_datetime) or (nw_start_datetime >= od_start_datetime and nw_end_datetime <= od_end_datetime)):
        cur = conn.cursor()
        sql = "UPDATE track SET start_date = %s, start_time = %s, weekday = %s, end_date = %s, end_time = %s, category_id = %s, loaction_id = %s, place_id = %s, user_id = %s WHERE start_time = %s AND end_time = %s AND user_id = %s"
        adr = (new_start_date, new_start_time, new_weekday, new_end_date, new_end_time, new_category_id,
               new_location_id, new_place_id, od_start_datetime, od_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        if(new_start_time > new_end_time):
            cur = conn.cursor()
            sql = "UPDATE track SET start_date = %s, start_time = %s, weekday = %s WHERE CONCAT(start_date, start_time) = %s AND user_id = %s"
            adr = (new_end_date, new_end_time, new_weekday+1, od_end_datetime, user_id)
            cur.execute(sql, adr)
            conn.commit()
            cur.close()
        else:
            cur = conn.cursor()
            sql = "UPDATE track SET start_date = %s, start_time = %s WHERE CONCAT(start_date, start_time) = %s AND user_id = %s"
            adr = (new_end_date, new_end_time, od_end_datetime, user_id)
            cur.execute(sql, adr)
            conn.commit()
            cur.close()
        cur = conn.cursor()
        sql = "UPDATE track SET end_date = %s, end_time = %s WHERE CONCAT(end_date, end_time) = %s AND user_id = %s"
        adr = (new_start_date, new_start_time, od_start_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        return jsonify({"status_code": 200})
    else:
        return jsonify({"status_code": 400})

    # cur = mysql.connection.cursor()
    # sql = "SELECT user_id FROM session WHERE session_id = %s;"
    # adr = (session_id)
    # cur.execute(sql, adr)
    # fetch_data = cur.fetchall()
    # user_id = fetch_data[0][0]
    # cur.close()

    # cur = conn.cursor()
    # sql = "UPDATE track SET (track_id, start_date, start_time, end_date, end_time, category_id, loaction_id, place_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s) WHERE user_id = %s"
    # adr = (track_id, start_date, start_time, end_date, end_time, category_id, location_id, place_id, user_id)
    # cur.execute(sql, adr)
    # conn.commit()
    # cur.close()
    # return jsonify({"status_code": 200})


@app.route("/deleteTrack", methods=["POST"])
def deleteTrack():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()
    user_id = data["user_id"]
    start_date = data["start_date"]
    start_time = data["start_time"]

    cur = conn.cursor()
    sql = "UPDATE track SET category_id = %s WHERE CONCAT(start_date, start_time) = %s AND user_id = %s"
    adr = (19, start_date, start_time, user_id)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()


@app.route("/insertTrack", methods=["POST"])
def insertTrack():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()

    user_id = data["user_id"]
    start_date = data["start_date"]
    start_time = data["start_time"]
    weekday = data["weekday"]
    end_date = data["end_date"]
    end_time = data["end_time"]
    map_id = int(data["map_id"])
    category_id = int(data["category_id"])
    location_id = int(data["location_id"])
    place_id = int(data["place_id"])
    record = 1

    nw_start_datetime = start_date + start_time
    nw_end_datetime = end_date + end_time

    # 新增insert資料
    cur = conn.cursor()
    sql = "INSERT INTO track(user_id, start_date, start_time, weekday, end_date, end_time, category_id, location_id, place_id, map_id, record) VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
    adr = (user_id, start_date, start_time, weekday, end_date,
           end_time, category_id, location_id, place_id, map_id, record)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()

    # start_time有被包含在其中一筆
    cur = conn.cursor()
    sql = "SELECT track_id, category_id FROM track WHERE CONCAT(end_date, end_time) > %s AND CONCAT(start_date, start_time) < %s AND user_id = %s"
    adr = (nw_start_datetime, nw_start_datetime, user_id)
    cur.execute(sql, adr)
    fetch_data = cur.fetchall()
    cur.close()
    if(fetch_data[0][1] == category_id):
        cur = conn.cursor()
        sql = "SELECT start_date, start_time FROM track WHERE track_id = %s"
        adr = (fetch_data[0][0])
        cur.execute(sql, adr)
        fetch_time = cur.fetchall()
        cur.close()

        cur = conn.cursor()
        sql = "UPDATE track SET start_date = %s, start_time = %s WHERE start_date = %s and start_time = %s and user_id = %s"
        adr = (fetch_time[0][0], fetch_time[0][1],
               start_date, start_time, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()

    else:
        cur = conn.cursor()
        sql = "UPDATE track SET end_date = %s, end_time = %s WHERE track_id = %s"
        adr = (start_date, start_time, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()

    # end_time被包含在其中一筆
    cur = conn.cursor()
    sql = "SELECT track_id, category_id FROM track WHERE CONCAT(end_date, end_time) > %s AND CONCAT(start_date, start_time) < %s AND user_id = %s"
    adr = (nw_end_datetime, nw_end_datetime, user_id)
    cur.execute(sql, adr)
    fetch_data = cur.fetchall()
    cur.close()

    if(fetch_data[0][1] == category_id):
        cur = conn.cursor()
        sql = "SELECT end_date, end_time FROM track WHERE track_id = %s"
        adr = (fetch_data[0][0])
        cur.execute(sql, adr)
        fetch_time = cur.fetchall()
        cur.close()

        cur = conn.cursor()
        sql = "UPDATE track SET end_date = %s, end_time = %s WHERE end_date = %s and end_time = %s and user_id = %s"
        adr = (fetch_time[0][0], fetch_time[0][1], end_date, end_time, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()

    else:
        cur = conn.cursor()
        sql = "UPDATE track SET start_date = %s, start_time = %s WHERE track_id = %s"
        adr = (end_date, end_time, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()

    # 有資料完全包含於insert裡
    cur = conn.cursor()
    sql = "SELECT track_id WHERE start_date between %s and %s AND start_time between %s and %s AND end_date between %s and %s AND end_time between %s and %s AND user_id = %s"
    adr = (start_date, end_date, start_time, end_time,
           start_date, end_date, start_time, end_time, user_id)
    cur.execute(sql, adr)
    fetch_data = cur.fetchall()
    cur.close()

    for data in fetch_data:
        cur = conn.cursor()
        sql = "DELETE FROM track WHERE track_id = %s"
        adr = (data)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()

    # 覆寫包含下一筆
#     cur = conn.cursor()
#     sql = "SELECT category_id FROM track WHERE CONCAT(start_date, start_time) > %s AND CONCAT(start_date, start_time) < %s AND user_id = %s"
#     adr = (nw_start_datetime, nw_end_datetime, user_id)
#     cur.execute(sql, adr)
#     fetch_data = cur.fetchall()
#     cur.close()
#     if(len(fetch_data) == 1):
#         if(category_id != fetch_data):
#             cur = conn.cursor()
#             sql = "DELETE FROM track WHERE CONCAT(start_date, start_time) < %s and CONCAT(start_date, start_time) > %s AND CONCAT(end_date, end_time) < %s and CONCAT(end_date, end_time) > %s AND user_id = %s"
#             adr = (nw_start_datetime, nw_end_datetime)
#             cur = conn.cursor()
#             sql = "UPDATE track SET(start_date, start_time) VALUES(%s, %s) WHERE "
#             adr = (end_date, end_time)


# # 若insert在上一段的最後,延長
#     nw_end_datetime = end_date + end_time
#     nw_start_datetime = start_date + start_time
#     cur = conn.cursor()
#     sql = "SELECT category_id FROM track WHERE CONCAT(end_date, end_time) = %s AND user_id = %s"
#     adr = (nw_start_datetime, user_id)
#     cur.execute(sql, adr)
#     fetch_data = cur.fetchall
#     cur.close()
#     if(fetch_data == category_id):
#         cur = conn.cursor()
#         sql = "UPDATE track SET (end_date, end_time) VALUES (%s, %s) WHERE user_id = %s AND CONCAT(end_date, end_time) = %s"
#         adr = (end_date, end_time, user_id, nw_start_datetime)
#         cur.execute(sql, adr)
#         conn.commit()
#         cur.close()

# # 若insert在下一段的前面,延長
#     cur = conn.cursor()
#     sql = "SELECT category_id FROM track WHERE CONCAT(start_date, start_time) = %s AND user_id = %s"
#     adr = (nw_end_datetime, user_id)
#     cur.execute(sql, adr)
#     fetch_data = cur.fetchall
#     cur.close()
#     if(fetch_data == category_id):
#         cur = conn.cursor()
#         sql = "UPDATE track SET (start_date, start_time) VALUES (%s, %s) WHERE user_id = %s AND CONCAT(start_date, start_time) = %s"
#         adr = (start_date, start_time, user_id, nw_end_datetime)
#         cur.execute(sql, adr)
#         conn.commit()
#         cur.close()

#     elif(len(fetch_data) == 0):
#     cur = conn.cursor()
#     sql = "INSERT INTO track (start_date, start_time, end_date, end_time, category_id, location_id, place_id, user_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
#     adr = (start_date, start_time, end_date, end_time,
#            category_id, location_id, place_id, user_id)
#     cur.execute(sql, adr)
#     conn.commit()
#     cur.close()

#     return jsonify({"status_code": 200})


@app.route("/insertCategory", methods=["POST"])
def insertCategory():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()

    user_id = dara["user_id"]
    category_id = int(data["category_id"])
    category_name = data["category_name"]
    category_color = data["category_color"]
    category_image = data["category_image"]

    cur = conn.cursor()
    sql = "INSERT INTO category (category_id, category_name, category_color, category_image, user_id) VALUES (%s, %s, %s, %s, %s)"
    adr = (category_id, category_name, category_color, category_image, user_id)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()
    return jsonify({"status_code": 200})


@app.route("/register", methods=["POST"])
def register():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()
    email = str(data["email"])
    print("current email"+email)
    password = str(data["password"])
    user_name = str(data["user_name"])
    cur = conn.cursor()
    sql_precheck = "SELECT * FROM user WHERE email = %s"
    adr_precheck = (email,)
    cur.execute(sql_precheck, adr_precheck)
    fetch_data = cur.fetchall()
    cur.close()
    if fetch_data:
        print(400)
        return jsonify({"status_code": 400, "user_id": 0})
    cur = conn.cursor()
    sql = "INSERT INTO user (email, password, user_name) VALUES (%s, %s, %s)"
    adr = (email, password, user_name)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()
    cur = conn.cursor()
    sql_precheck = "SELECT user_id FROM user WHERE email = %s"
    adr_precheck = (email,)
    cur.execute(sql_precheck, adr_precheck)
    fetch_data = cur.fetchall()
    cur.close()
    # session_id = uuid.uuid1()
    # cur = mysql.connection.cursor()
    # sql = "INSERT INTO session (session_id, user_id, is_login) VALUES (%s, %s, %s);"
    # adr = (session_id, fetch_data[0][0], True)
    # cur.execute(sql, adr)
    # mysql.connection.commit()
    # cur.close()
    print(200)
    return jsonify({"status_code": 200, "user_id": fetch_data[0][0]})


@app.route("/login", methods=["POST"])
def login():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()
    # print(data)
    email = data["email"]
    password = data["password"]
    # print(email,password)
    cur = conn.cursor()
    sql = "SELECT user_id FROM user WHERE email = %s and password = %s"
    adr = (email, password)
    cur.execute(sql, adr)
    fetch_data = cur.fetchall()
    cur.close()
    print(fetch_data[0][0])
    if fetch_data:
        return jsonify({"status_code": 200, "user_id": fetch_data[0][0]})
    else:
        return jsonify({"status_code": 400, "user_id": 0})


# @app.route("/logout", methods=["POST"])
# def logout():
#     try:
#         data = request.get_json()
#         session_id = data["session_id"]
#         print(session_id)
#         cur = mysql.connection.cursor()
#         sql = "DELETE FROM session WHERE session_id = %s"
#         adr = (session_id,)
#         cur.execute(sql, adr)
#         mysql.connection.commit()
#         cur.close()
#         return jsonify({"status_code": 200})
#     except:4
#         return jsonify({"status_code": 400})
if __name__ == "__main__":
    app.run(host="140.119.19.42")
