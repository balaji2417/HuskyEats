import base64

import pymysql
import random
import mysql.connector
from mysql.connector import Error

conn = mysql.connector.connect(
    host="localhost",  # Change to your host, e.g., "127.0.0.1" or "your_host"
    user="root",  # Replace with your MySQL username
    password="UshaUV1!",  # Replace with your MySQL password
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


def updateItemQuantityInCart(username, item, store_id, qty_change):
    cursor = conn.cursor()
    
    # Select cart_id and current quantity from the cart
    query = "SELECT cart_id, items_qty FROM cart WHERE username = %s AND items_name = %s AND store_id = %s"
    cursor.execute(query, (username, item, store_id))
    rows = cursor.fetchone()
    if rows is not None:
        cart_id = rows[0]
        current_qty = rows[1]
        new_qty = current_qty + qty_change
        
        if new_qty > 0:
            update_query = "UPDATE cart SET items_qty = %s WHERE cart_id = %s AND items_name = %s"
            cursor.execute(update_query, (new_qty, cart_id, item))
            conn.commit()
        elif new_qty == 0:
            delete_query = "DELETE FROM cart WHERE cart_id = %s"
            cursor.execute(delete_query, (cart_id,))
            conn.commit()
    else:
        print(f"Item {item} not found in the cart.")

def deleteItemFromCart(username, item, store_id):
    cursor = conn.cursor()
    
    # Delete the item from the cart based on username, item, and store_id
    delete_query = "DELETE FROM cart WHERE username = %s AND items_name = %s AND store_id = %s"
    cursor.execute(delete_query, (username, item, store_id))
    
    # Commit the changes to the database
    conn.commit()

    # Print a message indicating success or failure
    if cursor.rowcount > 0:
        print(f"Item {item} removed from the cart.")
    else:
        print(f"Item {item} not found in the cart.")

import random

def place_order(username, total_price, delivery_location):
    cursor = conn.cursor()
    
    try:
        # Generate OTP for the order (6-digit)
        otp = random.randint(1000, 9999)
        
        # Insert a new order into the 'orders' table
        insert_order_query = """
            INSERT INTO orders (username, Total_amount, delivery_location, iaAssigned, isDelivered, OTP)
            VALUES (%s, %s, %s, 0, 0, %s)
        """
        cursor.execute(insert_order_query, (username, total_price, delivery_location, otp))
        
        # Commit the transaction to save the order in the database
        conn.commit()

        # Get the order_id of the newly created order
        order_id = cursor.lastrowid

        # Retrieve cart items for the user (items that are not yet placed in an order)
        get_cart_items_query = """
            SELECT cart_id, store_id, items_name, items_qty, items_price
            FROM cart
            WHERE username = %s AND is_order_placed = 0
        """
        cursor.execute(get_cart_items_query, (username,))
        cart_items = cursor.fetchall()

        if not cart_items:
            return "No items in the cart or items have already been ordered."

        # Update the cart items to mark them as ordered and link them to the new order
        update_cart_query = """
            UPDATE cart
            SET is_order_placed = 1, order_id = %s
            WHERE cart_id = %s
        """
        
        # Update each cart item to set 'is_order_placed = 1' and associate with the new order
        for item in cart_items:
            cart_id = item[0]
            cursor.execute(update_cart_query, (order_id, cart_id))
        
        # Commit the updates to the cart table
        conn.commit()
        
        # Return success message with OTP
        return f"Order placed successfully! Your OTP is {otp}"

    except Error as e:
        conn.rollback()  # Rollback in case of any error
        print(f"Error occurred: {str(e)}")
        return f"Failed to place order: {str(e)}"




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

