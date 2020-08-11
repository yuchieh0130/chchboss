from flask import Flask ,jsonify, request
from flask_mysqldb import MySQL
import mysql.connector
import uuid
app = Flask(__name__) 


conn = mysql.connector.Connect(host='localhost', user='root',password='chchboss',database='mo')

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
    cur = conn.cursor()
    cur.execute("SELECT * FROM appdb.test")
    results = cur.fetchall()
    print(results)
    cur.close()
    return jsonify(results)



@app.route("/testInsert",methods=["GET"])
def inserttest():
    cur = conn.cursor()
    sql = "INSERT INTO test (test_id, test_number, test_null) VALUES (%s, %s, %s)"
    val = ("1234567890", "12345678","123")
    cur.execute(sql, val)
    conn.commit()
    cur.close()
    return jsonify({"status_code": 200})

@app.route("/insertLocation", methods=["POST"])
def insertLocation():
    data = request.get_json()
    
    location_id = data["location_id"]
    longitude = data["longitude"]
    latitude = data["latitude"]
    start_time = data["start_time"]
    duration = data["duration"]
    speed = data["speed"]
    name1 = data["name1"]
    name2 = data["name2"]
    name3 = data["name3"]
    name4 = data["name4"]
    name5 = data["name5"]
    category1 = data["category1"]
    category2 = data["category2"]
    category3 = data["category3"]
    category4 = data["category4"]
    category5 = data["category5"] 
    
    user_id  = data["user_id"]

    cur = conn.cursor()
    sql = "INSERT INTO location (location_id, longitude, latitude, start_time, duration, speed, speed, name1, name2, name3, name4, name5, category1, category2, category3, category4, category5, user_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
    adr = (location_id, longitude, latitude, start_time, duration, speed, speed, name1, name2, name3, name4, name5, category1, category2, category3, category4, category5, user_id)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()
    return jsonify({"status_code": 200})

@app.route("/insertSaveplace", methods=["POST"])
def insertSaveplace():
    data = request.get_json()

    place_id = data["place_id"]
    place_name = data["place_name"]
    place_longitude = data["place_longitude"]
    place_latitude = data["place_latitude"]
    my_place = data["my_place"]

    user_id  = data["user_id"]

    cur = conn.cursor()
    sql = "INSERT INTO saveplace (place_id, place_name, place_longitude, place_latitude, my_place, user_id) VALUES (%s, %s, %s, %s, %s, %s)"
    adr = (place_id, place_name, place_longitude, place_latitude, my_place, user_id)
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
    data = request.get_jon()
    
    last_track_id = data["last_track_id"]
    user_id = data["user_id"]

    cur = conn.cursor()
    sql = "SELECT * FROM location WHERE user_id = %s AND location_id > %s"
    adr = (user_id, last_track_id)
    cur.execute()
    fetch_data = fetchall()
    print(fetch_data)

@app.route("/updateTrack", methods=["POST"])
def updateTrack():
    data = request.get_json()

    # track_id = data["track_id"]
    
    new_start_date = data["new_start_date"]
    new_start_time = data["new_start_time"]
    new_end_date = data["new_end_date"]
    new_end_time = data["new_end_time"]
    new_category_id = data["new_category_id"]
    new_location_id = data["new_location_id"]
    new_place_id = data["new_place_id"]
    old_start_date = data["old_start_date"]
    old_start_time = data["old_start_time"]
    old_end_date = data["old_end_date"]
    old_end_time = data["old_end_time"]
    old_category_id = data["old_category_id"]
    old_location_id = data["old_location_id"]
    old_place_id = data["old_place_id"]

    user_id  = data["user_id"]

    nw_start_datetime = new_start_date + new_start_time
    od_start_datetime = old_start_date +old_start_time
    nw_end_datetime = new_end_date + new_end_time
    od_end_datetime = old_end_date + old_end_time


    if(nw_start_datetime>od_start_datetime and nw_end_datetime>od_end_datetime):
        cur = conn.cursor()
        sql = "DELETE FROM track WHERE CONCAT(start_date, start_time) between %s and %s AND CONCAT(end_date, end_time) between %s and %s AND user_id = %s"
        adr =(nw_start_datetime, nw_end_datetime, nw_start_datetime, nw_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "UPDATE track SET (start_date, start_time, end_time, category_id, location_id, place_id) VALUES (%s, %s, %s, %s, %s, %s) WHERE CONCAT(start_date, start_time) = %s AND CONCAT(end_date, end_time) = %s AND user_id = %s"
        adr = (new_start_date, new_start_time, nw_end_datetime, new_category_id, new_location_id, new_place_id, od_start_datetime, od_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "UPDATE track SET (start_date, start_time) VALUES(%s, %s) WHERE CONCAT(start_date, start_time) between %s and %s AND user_id = %s"
        adr = (new_end_date, new_end_time, nw_start_datetime, nw_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "UPDATE track SET (end_date, end_time) VALUES(%s, %s) WHERE CONCAT(end_date, end_time) = %s AND user_id = %s"
        adr = (new_start_date, new_start_time, od_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()        
        return jsonify({"status_code": 200})
    elif(nw_start_datetime<od_start_datetime and nw_end_datetime<od_end_datetime):
        cur = conn.cursor()
        sql = "DELETE FROM track WHERE CONCAT(start_date, start_time) between %s and %s AND CONCAT(end_date, end_time) between %s and %s AND user_id = %s"
        adr =(nw_start_datetime, nw_end_datetime, nw_start_datetime, nw_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "UPDATE track SET (start_date, start_time, end_date, end_time, category_id, location_id, place_id) VALUES (%s, %s, %s, %s, %s, %s) WHERE CONCAT(start_date, start_time) = %s AND CONCAT(end_date, end_time) = %s AND user_id = %s"
        adr = (new_start_date, new_start_time, new_end_date, new_end_time, new_category_id, new_location_id, new_place_id, od_start_datetime, od_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "UPDATE track SET (end_date, end_time) VALUES(%s, %s) WHERE CONCAT(end_date, end_time) between %s and %s AND user_id = %s"
        adr = (new_start_date, new_start_time, nw_start_datetime, nw_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "UPDATE track SET (start_date, start_time) VALUES(%s, %s) WHERE CONCAT(start_date, start_time) = %s AND user_id = %s"
        adr = (new_end_date, new_end_time, od_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()      
        return jsonify({"status_code": 200})
    elif(nw_start_datetime<od_start_datetime and nw_end_datetime>od_end_datetime):
        cur = conn.cursor()
        sql = "DELETE FROM track WHERE CONCAT(start_date, start_time) between %s and %s AND CONCAT(end_date, end_time) between %s and %s AND user_id = %s"
        adr =(nw_start_datetime, nw_end_datetime, nw_start_datetime, nw_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "INSERT INTO track(start_date, start_time, end_date, end_time, category_id, loaction_id, place_id, user_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
        adr = (new_start_date, new_start_time, new_end_date, new_end_time, new_category_id, new_location_id, new_place_id, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "UPDATE track SET (end_date, end_time) VALUES(%s, %s) WHERE CONCAT(end_date, end_time) between %s and %s AND user_id = %s"
        adr = (new_start_date, new_start_time, nw_start_datetime, nw_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "UPDATE track SET (start_date, start_time) VALUES(%s, %s) WHERE CONCAT(start_date, start_time) between %s and %s AND user_id = %s"
        adr = (new_end_date, new_end_time, nw_start_datetime, nw_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        return jsonify({"status_code": 200})
    elif(nw_start_datetime>od_start_datetime and nw_end_datetime<od_end_datetime):
        cur = conn.cursor()
        sql = "UPDATE track SET (start_date, start_time, end_date, end_time, category_id, loaction_id, place_id, user_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s) WHERE start_time = %s AND end_time = %s AND user_id = %s"
        adr = (new_start_date, new_start_time, new_end_date, new_end_time, new_category_id, new_location_id, new_place_id, od_start_datetime, od_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        cur = conn.cursor()
        sql = "UPDATE track SET (start_date, start_time) VALUES(%s, %s) WHERE CONCAT(start_date, start_time) = %s AND user_id = %s"
        adr = (new_end_date, new_end_time, od_end_datetime, user_id)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()  
        cur = conn.cursor()
        sql = "UPDATE track SET (end_date, end_time) VALUES(%s, %s) WHERE CONCAT(end_date, end_time) = %s AND user_id = %s"
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
    data = request.get_json()
    start_date = data["start_date"]
    start_time = data["start_time"]
    end_date = data["end_date"]
    end_time = data["end_time"]
    category_id = data["category_id"]
    loaction_id = data["loaction_id"]
    place_id = data["place_id"]
    user_id = data["user_id"]

    cur = conn.cursor()
    sql = "UPDATE track SET(category_id) VALUES(%s) WHERE CONCAT(start_date, start_time) = %s AND user_id = %s"
    adr = (19, start_date, start_time, user_id)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()

@app.route("/insertTrack", methods=["POST"])
def insertTrack():
    data = request.get_json()

    start_date = data["start_date"]
    start_time = data["start_time"]
    end_date = data["end_date"]
    end_time = data["end_time"]
    category_id = data["category_id"]
    loaction_id = data["loaction_id"]
    place_id = data["place_id"]
    user_id = data["user_id"]

    nw_end_datetime = end_date + end_time
    nw_start_datetime = start_date + start_time
    cur = conn.cursor()
    sql = "SELECT category_id FROM track WHERE CONCAT(end_date, end_time) = %s AND user_id = %s"
    adr = (nw_start_datetime, user_id)
    cur.execute(sql, adr)
    fetch_data = cur.fetchall
    cur.close()
    if(fetch_data == category_id):
        cur = conn.cursor()
        sql = "UPDATE track SET (end_date, end_time) VALUES (%s, %s) WHERE user_id = %s AND CONCAT(end_date, end_time) = %s"
        adr = (end_date, end_time, user_id, nw_start_datetime)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()

    cur = conn.cursor()
    sql = "SELECT category_id FROM track WHERE CONCAT(start_date, start_time) = %s AND user_id = %s"
    adr = (nw_end_datetime, user_id)
    cur.execute(sql, adr)
    fetch_data = cur.fetchall
    cur.close()
    if(fetch_data == category_id):
        cur = conn.cursor()
        sql = "UPDATE track SET (start_date, start_time) VALUES (%s, %s) WHERE user_id = %s AND CONCAT(start_date, start_time) = %s"
        adr = (start_date, start_time, user_id, nw_end_datetime)
        cur.execute(sql, adr)
        conn.commit()
        cur.close()
        
    cur = conn.cursor()
    sql = "INSERT INTO track (start_date, start_time, end_time, category_id, location_id, place_id, user_id) VALUES (%s, %s, %s, %s, %s, %s, %s)"
    adr = (start_date, start_time, end_time, category_id, loaction_id, place_id, user_id)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()


    return jsonify({"status_code": 200})

@app.route("/insertCategory", methods=["POST"])
def insertCategory():
    data = request.get_json()

    category_id = data["category_id"]
    category_name = data["category_name"]
    category_color = data["category_color"]
    category_image = data["category_image"]

    cur = conn.cursor()
    sql = "INSERT INTO category (category_id, category_name, category_color, category_image) VALUES (%s, %s, %s, %s)"
    adr = (category_id, category_name, category_color, category_image)
    cur.execute(sql, adr)
    conn.commit()
    cur.close()
    return jsonify({"status_code": 200})




@app.route("/register", methods=["POST"])
def register():
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
    # print(fetch_data[0][0])
    if fetch_data:
        return jsonify({"status_code": 200, "user_id": fetch_data[0][0]})
    else:
        return jsonify({"status_code": 400,"user_id": 0})
    

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
    app.run(host = "140.119.19.42")
