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
    region_radius = data["region_radius"]
    print(my_place)
    print(type(my_place))
    cur = conn.cursor()
    sql = "INSERT INTO savedplace (user_place_id, place_name, place_category, place_longitude, place_latitude, my_place, user_id, regionradius) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
    adr = (user_place_id, place_name, place_category, place_longitude,
           place_latitude, my_place, user_id, region_radius)
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
    region_radius = data["region_radius"]

    cur = conn.cursor()
    sql = "UPDATE savedplace SET place_name = %s, place_category = %s, place_longitude = %s, place_latitude = %s, my_place = %s, regionradius = %s WHERE user_id = %s AND user_location_id = %s"
    adr = (place_name, place_category, place_longitude, place_latitude,
           my_place, region_radius, user_id, user_place_id)
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

@app.route("/pushSavedplace", methods=["POST"])
def pushSavedplace():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()

    user_id = data["user_id"]
    print(123,user_id)

    cur = conn.cursor()
    sql = "SELECT user_place_id, place_name, place_category, place_longitude, place_latitude, my_place, regionradius FROM savedplace WHERE user_id = %s"
    adr = (user_id,)
    cur.execute(sql, adr)
    fetch_data = cur.fetchall()
    cur.close()
    if(fetch_data):
        return jsonify({"status_code": 200, "data":fetch_data})
    else:
        return jsonify({"status_code": 400})




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
    print("first:",last_track_id)

    cur = conn.cursor()
    sql = "SELECT * FROM track WHERE user_id = %s AND track_id > %s AND record = 0"
    adr = (user_id, last_track_id)
    cur.execute(sql, adr)
    fetch_data = cur.fetchall()
    if(fetch_data):
        track_data = fetch_data
        last_track_id = track_data[-1][0]
        cur.close()
        print("last:",last_track_id)

    # cur = conn.cursor()
    # sql = "UPDATE track SET record = %s WHERE user_id = %s AND record = %s"
    # adr = (True, user_id, False)
    # cur.execute(sql, adr)
    # conn.commit()
    # cur.close()

        return jsonify({"status_code": 200,
                        "data": track_data,
                        "last_track_id": last_track_id})
    else:
        return jsonify({"status_code": 400})

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
        return jsonify({"status_code": 200})
    # 7-11 -> 8-13
    elif(nw_start_datetime > od_start_datetime and nw_end_datetime > od_end_datetime):
        cur = conn.cursor()
        sql = "DELETE FROM track WHERE CONCAT(start_date, start_time) between %s and %s AND CONCAT(end_date, end_time) between %s and %s AND user_id = %s"
        adr = (nw_start_datetime, nw_end_datetime,
               nw_start_datetime, nw_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()


        # cur = conn.cursor()
        # sql = "UPDATE track SET start_date = %s, start_time = %s, weekday = %s WHERE CONCAT(start_date, start_time) between %s and %s AND user_id = %s"
        # adr = (new_end_date, new_end_time, new_weekday,
        #        nw_start_datetime, nw_end_datetime, user_id)
        # cur.execute(sql, adr)
        # conn.commit()
        # cur.close()
        
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

        cur = conn.cursor()
        sql = "INSERT INTO track (start_date, start_time, weekday, end_date, end_time, category_id, place_id, location_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
        adr = (old_start_date, old_start_time, old_weekday, new_start_date,
               new_start_time, 19, old_place_id, old_location_id)
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
        return jsonify({"status_code": 200})
    # 7-11-> 5-10
    elif(nw_start_datetime < od_start_datetime and nw_end_datetime < od_end_datetime):
        cur = conn.cursor()
        sql = "DELETE FROM track WHERE CONCAT(start_date, start_time) between %s and %s AND CONCAT(end_date, end_time) between %s and %s AND user_id = %s"
        adr = (nw_start_datetime, nw_end_datetime,
               nw_start_datetime, nw_end_datetime, user_id)
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

        cur = conn.cursor()
        sql = "INSERT INTO track (start_date, start_time, weekday, end_date, end_time, category_id, place_id, location_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
        adr = (new_end_date, new_end_time, new_weekday, old_end_date,
               old_end_time, 19, old_place_id, old_location_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()

        # if(new_start_time > new_end_time):
        #     cur = conn.cursor()
        #     sql = "UPDATE track SET start_date = %s, start_time = %s, weekday = %s WHERE CONCAT(start_date, start_time) = %s AND user_id = %s"
        #     adr = (new_end_date, new_end_time,
        #            new_weekday+1, od_end_datetime, user_id)
        #     cur.execute(sql, adr)
        #     conn.commit()
        #     cur.close()
        # else:
        #     cur = conn.cursor()
        #     sql = "UPDATE track SET start_date = %s, start_time = %s WHERE CONCAT(start_date, start_time) = %s AND user_id = %s"
        #     adr = (new_end_date, new_end_time, od_end_datetime, user_id)
        #     cur.execute(sql, adr)
        #     conn.commit()
        #     cur.close()

        cur = conn.cursor()
        sql = "UPDATE track SET start_date = %s, start_time = %s, weekday = %s, end_date = %s, end_time = %s, category_id = %s, location_id = %s, place_id = %s WHERE CONCAT(start_date, start_time) = %s AND CONCAT(end_date, end_time) = %s AND user_id = %s"
        adr = (new_start_date, new_start_time, new_weekday, new_end_date, new_end_time, new_category_id,
               new_location_id, new_place_id, od_start_datetime, od_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        return jsonify({"status_code": 200})

    # 7-11->5-13 or 7-11-> (5-13,7-13) or 7-11->(5-13,5-11)
    elif((nw_start_datetime < od_start_datetime and nw_end_datetime > od_end_datetime) or (nw_start_datetime <= od_start_datetime and nw_end_datetime > od_end_datetime) or (nw_start_datetime < od_start_datetime and nw_end_datetime >= od_end_datetime)):
        cur = conn.cursor()
        sql = "DELETE FROM track WHERE CONCAT(start_date, start_time) between %s and %s AND CONCAT(end_date, end_time) between %s and %s AND user_id = %s"
        adr = (nw_start_datetime, nw_end_datetime,
               nw_start_datetime, nw_end_datetime, user_id)
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

        cur = conn.cursor()
        sql = "INSERT INTO track(start_date, start_time, weekday, end_date, end_time, category_id, location_id, place_id, user_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)"
        adr = (new_start_date, new_start_time, new_weekday, new_end_date, new_end_time,
               new_category_id, new_location_id, new_place_id, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        return jsonify({"status_code": 200})
    # 7-11 -> 8-10 or 7-11 -> 7-10 or 7-11 -> 8-11
    elif((nw_start_datetime > od_start_datetime and nw_end_datetime < od_end_datetime) or (nw_start_datetime >= od_start_datetime and nw_end_datetime < od_end_datetime) or (nw_start_datetime >= od_start_datetime and nw_end_datetime <= od_end_datetime)):
        cur = conn.cursor()
        sql = "UPDATE track SET start_date = %s, start_time = %s, weekday = %s, end_date = %s, end_time = %s, category_id = %s, loaction_id = %s, place_id = %s, user_id = %s WHERE start_time = %s AND end_time = %s AND user_id = %s"
        adr = (new_start_date, new_start_time, new_weekday, new_end_date, new_end_time, new_category_id,
               new_location_id, new_place_id, od_start_datetime, od_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        if(new_start_time != old_start_time):
            cur = conn.cursor()
            sql = "INSERT INTO track (start_date, start_time, weekday, end_date, end_time, category_id, place_id, location_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
            adr = (old_start_date, old_start_time, new_weekday, new_start_date,
                new_start_time, 19, old_place_id, old_location_id)
            cur.execute(sql, adr)
            conn.commit()
            cur.close()
        if(new_end_time != old_end_time):
            cur = conn.cursor()
            sql = "INSERT INTO track (start_date, start_time, weekday, end_date, end_time, category_id, place_id, location_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
            adr = (new_end_date, new_end_time, new_weekday, old_end_date,
                old_end_time, 19, old_place_id, old_location_id)
            cur.execute(sql, adr)
            conn.commit()
            cur.close()

        # if(new_start_time > new_end_time):
        #     cur = conn.cursor()
        #     sql = "UPDATE track SET start_date = %s, start_time = %s, weekday = %s WHERE CONCAT(start_date, start_time) = %s AND user_id = %s"
        #     adr = (new_end_date, new_end_time, new_weekday+1, od_end_datetime, user_id)
        #     cur.execute(sql, adr)
        #     conn.commit()
        #     cur.close()
        # else:
        #     cur = conn.cursor()
        #     sql = "UPDATE track SET start_date = %s, start_time = %s WHERE CONCAT(start_date, start_time) = %s AND user_id = %s"
        #     adr = (new_end_date, new_end_time, od_end_datetime, user_id)
        #     cur.execute(sql, adr)
        #     conn.commit()
        #     cur.close()
        # cur = conn.cursor()
        # sql = "UPDATE track SET end_date = %s, end_time = %s WHERE CONCAT(end_date, end_time) = %s AND user_id = %s"
        # adr = (new_start_date, new_start_time, od_start_datetime, user_id)
        # cur.execute(sql, adr)
        # conn.commit()
        # cur.close()
        # return jsonify({"status_code": 200})
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
    new_start_time = start_date+start_time
    cur = conn.cursor()
    sql = "UPDATE track SET category_id = %s WHERE CONCAT(start_date, start_time) = %s AND user_id = %s"
    adr = (19, new_start_time, user_id)
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



@app.route("/linelogin", methods=["POST"])
def linelogin():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()

    user_lineid = data["user_lineid"]
    user_name = data["user_name"]

    cur = conn.cursor()
    sql = "SELECT user_id FROM user WHERE user_lineid = %s"
    adr = (user_lineid,)
    cur.execute(sql, adr)
    fetch_data = cur.fetchall()
    cur.close()
    if(fetch_data):
        return jsonify({"status_code": 200, "user_id":fetch_data[0][0]})
    else:
        cur = conn.cursor()
        sql = "INSERT INTO user (user_lineid, user_name) VALUES(%s, %s)"
        adr = (user_lineid, user_name)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()

        cur = conn.cursor()
        sql = "SELECT user_id FROM user WHERE user_lineid = %s"
        adr = (user_lineid,)
        cur.execute(sql, adr)
        fetch_data = cur.fetchall()
        cur.close()
        return jsonify({"status_code": 200, "user_id":fetch_data[0][0]})
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

@app.route("/searchFriendList", methods=["POST"])
def searchFriendList():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()

    user_id = data["user_id"]
    
    cur = conn.cursor()
    sql = "SELECT friend.*, user.user_id, user.user_name, user.liked, user.heart, user.mad FROM friend LEFT JOIN user ON friend.user_id = user.user_id WHERE friend.user_id = %s and friend.confirm_status = %s"
    adr = (user_id, True)
    cur.execute(sql, adr)
    confirm_friend = cur.fetchall()
    cur.close()
    cur = conn.cursor()
    sql = "SELECT friend_id, name FROM friend WHERE user_id = %s and confirm_status = %s"
    adr = (user_id, False)
    cur.execute(sql, adr)
    unconfirm_friend = cur.fetchall()
    cur.close()
    if(confirm_friend):
        return jsonify({"status_code": 400})
    else:
        return jsonify({"status_code": 200, "confirm_friendlist": confirm_friend[0], "unconfirm_friendlist": unconfirm_friend[0]})


@app.route("/searchFriend", methods=["POST"])
def searchFriend():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()

    user_id = data[user_id]
    
    cur = conn.cursor()
    sql = "SELECT user_name FROM user WHERE user_id = %s"
    adr = (user_id)
    cur.execute(sql, adr)
    fetch_data = cur.fetchall()
    cur.close()
    if(fetch_data):
        return jsonify({"status_code": 400})
    else:
        # friend = ["name"]
        return jsonify({"status_code": 200, "friend": fetch_data[0]})

@app.route("/addFriendRequest", methods=["POST"])
def addFriendRequest():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()

    user_id = data["user_id"]
    friend_id = data["friend_id"]

    cur = conn.cursor()
    sql = "SELECT user_id FROM friend WHERE user_id = %s and friend_id = %s UNION ALL SELECT user_id FROM friend WHERE user_id = %s and friend_id = %s "
    adr = (user_id, friend_id, friend_id, user_id)
    cur.execute(sql, adr)
    fetch_data = cur.fetchall()
    cur.close()
    if(fetch_data):
        return jsonify({"status_code": 400})
    cur = conn.cursor()
    sql = "INSERT INTO friend (user_id, friend_id, comfirm_status) VALUES(%s, %s, %s)"
    adr = (user_id, friend_id, False)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()
    return jsonify({"status_code": 200})

@app.route("/insertFriend", methods=["POST"])
def insertFriend():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()

    user_id = data["user_id"]
    friend_id = data["friend_id"]

    cur = conn.cursor()
    sql = "UPDATE user SET confirm_status = %s WHERE user_id = %s and friend_id = %s"
    adr = (True, user_id, friend_id)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()

@app.route("/deleteFriend", methods=["POST"])
def deleteFriend():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()

    user_id = data["user_id"]
    friend_id = data["friend_id"]

    cur = conn.cursor()
    sql = "DELETE * FROM user WHERE (user_id = %s and friend_id = %s) OR (user_id = %s and friend_id = %s)"
    adr = (True, user_id, friend_id, friend_id, user_id)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()

@app.route("/getEmoji", methods=["POST"])
def getEmoji():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()

    user_id = data["user_id"]

    cur = conn.cursor()
    sql = "SELECT liked, heart, mad FROM user WHERE user_id = %s"
    adr = (user_id,)
    cur.execute(sql, adr)
    fetch_data = cur.fetchall()
    cur.close()
    # emoji = [like, heart, mad]
    return jsonify({"status_code": 200, "emoji" :fetch_data[0]})

@app.route("/addEmoji", methods=["POST"])
def addEmoji():
    import mysql.connector
    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()

    emoji = data["emoji"]
    user_id = data["user_id"]

    if(emoji == "mad"):
        cur = conn.cursor()
        sql = "SELECT mad FROM user WHERE user_id = %s"
        adr = (user_id)
        cur.execute(sql, adr)
        fetch_data = cur.fetchall()[0][0]
        cur.close()
        
        cur = conn.cursor()
        sql = "UPDATE user SET mad = %s WHERE user_id = %s"
        adr = (fetch_data+1, user_id)
        conn.commit()
        cur.close()
        return jsonify({"status_code": 200})
    elif(emoji == "heart"):
        cur = conn.cursor()
        sql = "SELECT heart FROM user WHERE user_id = %s"
        adr = (user_id)
        cur.execute(sql, adr)
        fetch_data = cur.fetchall()[0][0]
        cur.close()

        cur = conn.cursor()
        sql = "UPDATE user SET heart = %s WHERE user_id = %s"
        adr = (fetch_data+1, user_id)
        conn.commit()
        cur.close()
        return jsonify({"status_code": 200})
    elif(emoji == "liked"):
        cur = conn.cursor()
        sql = "SELECT liked FROM user WHERE user_id = %s"
        adr = (user_id)
        cur.execute(sql, adr)
        fetch_data = cur.fetchall()[0][0]
        cur.close()
        
        cur = conn.cursor()
        sql = "UPDATE user SET liked = %s WHERE user_id = %s"
        adr = (fetch_data+1, user_id)
        conn.commit()
        cur.close()
        return jsonify({"status_code": 200})

@app.route("/rank", methods=["POST"])
def rank():
    import mysql.connector
    import re

    conn = mysql.connector.Connect(
        host='localhost', user='root', password='chchboss', database='mo')
    data = request.get_json()

    category = data["category"]
    current_time = data["currenttime"]
    
    timelist = re.split("/|:", current_time)

    current_datetime = datetime.datetime(int(timelist[0]), int(timelist[1]), int(timelist[2]), int(timelist[3]), int(timelist[4]), 00)
    week = current_datetime + datetime.timedelta(days=7)
    week = str(week).replace(" ","")
    current_time = str(current_time).replace(" ","")

    cur = conn.cursor()
    sql = "SELECT user_id ,duration FROM track WHERE category = %s and CONCAT(end_date, end_time) BETWEEN %s and %s" 
    adr = (category, current_time, week)
    cur.execute(sql, adr)
    fetch_data = cur.fetchall()
    cur.close()

    dic1 = {}
    for i in fetch_data:
        dic1[i[0]] = i[1]
    sortedlist = sorted(dic1.items(), key=lambda x:x[1])
    sortedlist = sortedlist[:-1]
    sortedlist = sortedlist[0:5]

    # sortedlist = [('user1', '20'), ('user3', '40'), ('user2', '50')]
    return jsonify({"status_code": 200, "sortedlist": sortedlist})



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

if __name__ == "__main__":
    app.run(host="140.119.19.42")
