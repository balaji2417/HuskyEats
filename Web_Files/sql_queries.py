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

    cur.execute("SELECT FOOD_IMAGE FROM menu")
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

def getCategory():
    cursor = conn.cursor()
    cursor.callproc('get_category')
    for results in cursor.stored_results():
        rows = results.fetchall()
        category = []
        for row in rows:
            category.append(row[0])
    return category

def get_grocery_category_list():
    cursor = conn.cursor()
    cursor.callproc('get_grocery_category')
    for results in cursor.stored_results():
        rows = results.fetchall()
        category = []
        for row in rows:
            category.append(row[0])
    return category

def get_top_stores():
    cursor = conn.cursor()
    cursor.callproc('get_top_menu')
    stores = []
    items = []
    prices = []
    images = []
    store_id=[]
    for results in cursor.stored_results():
        rows = results.fetchall()
        for row in rows:
            stores.append(row[0])
            items.append(row[1])
            prices.append("$"+str(row[2]))
            base64_image = base64.b64encode(row[3]).decode('utf-8')
            images.append(base64_image)
            store_id.append(row[4])
    return stores,items,prices,images,store_id

def get_menu_category(category_name):
    cursor = conn.cursor()
    cursor.callproc('get_menu_category',[category_name,])
    stores = []
    items = []
    prices = []
    images = []
    store_id = []
    for results in cursor.stored_results():
        rows = results.fetchall()
        for row in rows:
            stores.append(row[0])
            items.append(row[1])
            prices.append("$"+str(row[2]))
            base64_image = base64.b64encode(row[3]).decode('utf-8')
            images.append(base64_image)
            store_id.append(row[4])
    return stores,items,prices,images,store_id

def get_grocery_category(category_name):
    cursor = conn.cursor()
    cursor.callproc('get_grocery',[category_name,])
    stores = []
    items = []
    prices = []
    images = []
    store_id = []
    for results in cursor.stored_results():
        rows = results.fetchall()
        for row in rows:
            stores.append(row[0])
            items.append(row[1])
            prices.append("$"+str(row[2]))
            base64_image = base64.b64encode(row[3]).decode('utf-8')
            images.append(base64_image)
            store_id.append(row[4])
    return stores,items,prices,images,store_id

def updateCart(username,item,qty,price,store_id):
    cursor = conn.cursor()
    query = "SELECT cart_id from cart where username = %s AND items_name = %s AND store_id = %s"
    cursor.execute(query,(username,item,store_id))
    rows = cursor.fetchone()
    cart_id = 0
    if(rows is not None) :
        for row in rows:

            cart_id = row
    price_new = price.split("$")
    price = float(price_new[1])
    cursor.callproc('update_cart',[username,store_id,item,cart_id,price,qty])
    conn.commit()


def get_cart(username):
    cursor = conn.cursor()
    query = "SELECT * FROM cart where username = %s"
    cursor.execute(query,(username,))
    rows = cursor.fetchall()
    store_id = []
    item =[]
    price = []

    total = 0.0
    qty= []
    for row in rows:
        store_id.append(row[2])
        item.append(row[3])
        price.append("$"+str(row[4]))
        qty.append(row[5])
        total = total +( row[4] * row[5] )
    return store_id,item,price,total,qty

