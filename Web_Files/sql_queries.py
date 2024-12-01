import base64

import pymysql
import mysql.connector
from mysql.connector import Error

conn = mysql.connector.connect(
    host="localhost",  # Change to your host, e.g., "127.0.0.1" or "your_host"
    user="root",  # Replace with your MySQL username
    password="root",  # Replace with your MySQL password
    database="husky_eats"  # Replace with the database name
)


def get_images():
    cur = conn.cursor()

    cur.execute("SELECT IMAGE_FOOD FROM menu")
    rows = cur.fetchall()

    images = []
    print(len(rows))
    for row in rows:
        # Convert each image BLOB to Base64 string
        if (row[0] is None):
            print(row)
            continue
        base64_image = base64.b64encode(row[0]).decode('utf-8')
        images.append(base64_image)

    return images


def check_delivery(username, password):
    cursor = conn.cursor()
    query = "SELECT Password FROM delivery_agent WHERE Delivery_agent_id = %s"
    cursor.execute(query, (username,))
    rows = cursor.fetchall()
    flag = False
    for row in rows:
        print(row[0])
        if row[0] == password:
            flag = True

    return flag


def check_valid_user(username, password):
    cursor = conn.cursor()
    query = "SELECT user_password,user_type FROM customer WHERE username = %s"
    cursor.execute(query, (username,))
    rows = cursor.fetchall()
    flag = False
    type = ""
    for row in rows:
        if row[0] == password:
            flag = True
            type = row[1]
    cursor.execute("SELECT get_name(%s,%s)", (username, type))
    rows = cursor.fetchall()
    user_full_name = ""
    for row in rows:
        user_full_name = row[0]
    cursor.callproc('get_category')

    category = []
    for result in cursor.stored_results():
        rows = result.fetchall()
        for row in rows:
            category.append(row[0])

    return flag, user_full_name, category


def checkValidEntry(username, password, id, selected_value):
    cursor = conn.cursor()
    if selected_value == 'student':
        query = "SELECT * from student where NUID = %s"
        cursor.execute(query, (id,))
        row = cursor.fetchall()
        if len(row) <= 0:
            return False, "Reference Student does not exist"
        else:
            flag = False
            message = "Success"
            try:
                cursor.callproc('CustomerSignup', [username, password, selected_value, id])
                query = "UPDATE STUDENT SET username = %s where NUID = %s"
                cursor.execute(query, (username, id))
                flag = True


            except Error as e:
                print(e)
                message = str(e.msg)
                flag = False
            conn.commit()
            return flag, message





    elif selected_value == 'faculty':
        query = "SELECT * from neu_employee where faculty_id = %s"
        cursor.execute(query, (id,))
        row = cursor.fetchall()
        if len(row) < 0:
            return False, "Reference Faculty does not exist"
        else:
            flag = False
            message = "Success"
            try:
                cursor.callproc('CustomerSignup', [username, password, selected_value, id])
                flag = True
                query = "UPDATE NEU_EMPLOYEE SET username = %s where faculty_id = %s"
                cursor.execute(query, (username, id))

            except Error as e:
                print(e)
                message = str(e.msg)
                flag = False
            conn.commit()
            return flag, message
