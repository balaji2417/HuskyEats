import base64

import pymysql
import random
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import mysql.connector
from mysql.connector import Error

conn = mysql.connector.connect(
    host="localhost",  # Change to your host, e.g., "127.0.0.1" or "your_host"
    user="root",  # Replace with your MySQL username
    password="root",  # Replace with your MySQL password
    database="husky_eats"  # Replace with the database name
)
conn.commit()


def get_ordered_cart(order_ids):
    order_data = []
    for order_id in order_ids:
        sub_orders = []
        sub_orders.append(order_id)
        if (order_id is None):
            continue
        cursor = conn.cursor()
        query = "Select * from cart where order_id = %s"
        cursor.execute(query, (order_id,))
        rows = cursor.fetchall()
        for row in rows:
            items = []
            items.append(row[3])
            items.append(row[5])
            items.append("$" + str(row[4]))
            items.append("$" + str(row[5] * row[4]))
            sub_orders.append(items)
        order_data.append(sub_orders)

    return order_data


def get_building():
    cursor = conn.cursor()
    query = "SELECT building_name from building"
    cursor.execute(query)
    rows = cursor.fetchall()
    building = []
    for row in rows:
        building.append(row[0])
    cursor.close()
    return building


def get_orders(username):

    cursor = conn.cursor()

    # Updated query to join 'orders' with 'cart' using 'order_id' and select 'store_id' from 'cart'
    query = """
        SELECT order_id, Delivery_agent_id, Total_amount, iaAssigned, isDelivered
        FROM orders where username = %s
    """
    cursor.execute(query,(username,))
    rows = cursor.fetchall()

    order_id = []
    deliveryAgent = []
    status = []
    totalPrice = []
    store_id = []  # List to hold store_id values

    for row in rows:
        order_id.append(row[0])

        # Handle delivery agent
        if not row[3]:
            deliveryAgent.append("Delivery agent not assigned")
        else:
            deliveryAgent.append(row[1])

        # Handle order status
        if not row[3]:
            status.append("Order Placed")
        elif row[3] and not row[4]:
            status.append("On the way")
        else:
            status.append("Delivered")

        # Format total price
        totalPrice.append("$" + str(row[2]))

        # Append store_id (from cart)

    # Return all lists, including store_id
    cursor.close()
    return order_id, deliveryAgent, status, totalPrice


def get_Delivery_name(username):
    cursor = conn.cursor()
    query = "SELECT get_delivery_name(%s)"
    cursor.execute(query, (username,))
    rows = cursor.fetchall()
    user_name = ""
    for row in rows:
        user_name = row[0]
    cursor.close()
    return user_name


def get_orders_from_database(user_name):
    # Create a cursor object to interact with the database
    cursor = conn.cursor()

    # Query to fetch all orders' order_id and delivery_location
    query = """
    SELECT order_id, delivery_location,iaAssigned FROM orders
    WHERE iaAssigned = 0 or (iaAssigned = 1 and Delivery_agent_id = %s and isDelivered = 0)
    """
    cursor.execute(query, (user_name,))

    # Fetch all rows from the query result
    rows = cursor.fetchall()

    # List to store order information
    orders = []

    # Populate the orders list with each order's ID and delivery location
    for row in rows:
        order_id = row[0]
        delivery_location = row[1]
        isAssigned = row[2]
        print(isAssigned)
        # Append the order details to the orders list
        orders.append({
            'order_id': order_id,
            'delivery_location': delivery_location,
            'isAssigned': isAssigned
        })

    print(orders)
    cursor.close()
    return orders


def get_stores(orders):
    cur = conn.cursor()
    order_ids = []
    for order_dict in orders:
        order_ids.append(order_dict.get('order_id'))
    order_data = []
    for order_id in order_ids:
        sub_orders = []
        sub_orders.append(order_id)
        if (order_id is None):
            continue
        cursor = conn.cursor()
        query = "Select * from cart where order_id = %s"
        cursor.execute(query, (order_id,))
        rows = cursor.fetchall()
        for row in rows:
            items = []
            items.append(row[3])
            items.append(row[5])
            items.append("$" + str(row[4]))
            items.append("$" + str(row[5] * row[4]))
            cursor.execute("SELECT * FROM STORE where store_id = %s",(row[2],))
            rows_store = cursor.fetchone()
            items.append(rows_store[1])
            cursor.execute("SELECT * FROM BUILDING where building_id = %s",(rows_store[4],))
            rows_building = cursor.fetchone()
            items.append(rows_building[1])

            sub_orders.append(items)
        order_data.append(sub_orders)

    return order_data


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
    cursor.close()
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
    cursor.close()
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
    cursor.close()
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
        if len(row) <= 0:
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
    cursor.close()
    return category


def get_grocery_category_list():
    cursor = conn.cursor()
    cursor.callproc('get_grocery_category')
    for results in cursor.stored_results():
        rows = results.fetchall()
        category = []
        for row in rows:
            category.append(row[0])
    cursor.close()
    return category


def get_top_stores():
    cursor = conn.cursor()
    cursor.callproc('get_top_menu')
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
            prices.append("$" + str(row[2]))
            base64_image = base64.b64encode(row[3]).decode('utf-8')
            images.append(base64_image)
            store_id.append(row[4])
    cursor.close()
    return stores, items, prices, images, store_id


def get_menu_category(category_name):
    cursor = conn.cursor()
    cursor.callproc('get_menu_category', [category_name, ])
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
            prices.append("$" + str(row[2]))
            base64_image = base64.b64encode(row[3]).decode('utf-8')
            images.append(base64_image)
            store_id.append(row[4])
    cursor.close()
    return stores, items, prices, images, store_id


def get_grocery_category(category_name):
    cursor = conn.cursor()
    cursor.callproc('get_grocery', [category_name, ])
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
            prices.append("$" + str(row[2]))
            base64_image = base64.b64encode(row[3]).decode('utf-8')
            images.append(base64_image)
            store_id.append(row[4])
    cursor.close()
    return stores, items, prices, images, store_id


def updateCart(username, item, qty, price, store_id):
    cursor = conn.cursor()
    query = "SELECT cart_id from cart where username = %s AND items_name = %s AND store_id = %s AND is_order_placed = 0"
    cursor.execute(query, (username, item, store_id))
    rows = cursor.fetchone()
    cart_id = 0
    if (rows is not None):
        for row in rows:
            cart_id = row
    price_new = price.split("$")
    price = float(price_new[1])
    cursor.close()
    cursor1 = conn.cursor()
    cursor1.callproc('update_cart', [username, store_id, item, cart_id, price, qty])
    conn.commit()
    cursor.close()

def updateItemQuantityInCart(username, item, store_id, qty_change):
    cursor = conn.cursor()

    # Select cart_id and current quantity from the cart
    query = "SELECT cart_id, items_qty FROM cart WHERE username = %s AND items_name = %s AND store_id = %s AND is_order_placed = 0"
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
    cursor.close()

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
    cursor.close()

def place_order(username, total_price, delivery_location):
    cursor = conn.cursor()

    try:
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

        # Step 1: Check stock for each item (before inserting the order)
        for item in cart_items:
            store_id = item[1]
            item_name = item[2]
            item_qty = item[3]

            # If the store is a grocery, check the stock availability of the particular item
            if is_grocery_item(store_id, item_name):
                continue  # Check if it's a grocery item
            else:
                print("LOL")
                return f"Insufficient for item {item_name}, Qty : {item_qty}"
                    
        # Step 2: Now that all stock checks passed, insert the order into the 'orders' table
        otp = random.randint(1000, 9999)
        insert_order_query = """
            INSERT INTO orders (username, Total_amount, delivery_location, iaAssigned, isDelivered, OTP)
            VALUES (%s, %s, %s, 0, 0, %s)
        """
        cursor.execute(insert_order_query, (username, total_price, delivery_location, otp))

        # Commit the transaction to save the order in the database
        conn.commit()

        # Get the order_id of the newly created order
        order_id = cursor.lastrowid

        # Step 3: Update the cart and grocery stock
        update_cart_query = """
            UPDATE cart
            SET is_order_placed = 1, order_id = %s
            WHERE cart_id = %s
        """
        for item in cart_items:
            cart_id = item[0]
            store_id = item[1]
            item_name = item[2]
            item_qty = item[3]

            # Update the cart to mark the item as ordered and associate with the new order
            cursor.execute(update_cart_query, (order_id, cart_id))

            # If the store is a grocery, reduce the quantity in the grocery table
            if is_grocery_item(store_id, item_name):  # Check if it's a grocery item
                # Reduce the quantity in the grocery table
                reduce_grocery_qty_query = """
                    UPDATE grocery
                    SET item_qty = item_qty - %s
                    WHERE store_id = %s AND item_name = %s
                """
                cursor.execute(reduce_grocery_qty_query, (item_qty, store_id, item_name))

        # Commit the updates to the cart and grocery table
        conn.commit()

        # Send OTP email
        cursor.execute("SELECT get_email(%s)", (username,))
        email = ""
        rows = cursor.fetchall()
        for row in rows:
            email = row[0]

        sender_email = "balajisundar859@gmail.com"
        receiver_email = email
        msg = MIMEMultipart()
        msg['From'] = sender_email
        msg['To'] = receiver_email
        msg['Subject'] = "OTP for Order " + str(order_id)
        body = "OTP Is :" + str(otp)
        msg.attach(MIMEText(body, 'plain'))

        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()  # Start TLS (Transport Layer Security)
        server.login(sender_email, 'shpi ssli lsfx ahvt')  # Replace with your actual email password
        server.sendmail(sender_email, receiver_email, msg.as_string())
        server.quit()

        # Return success message with OTP
        return f"Order placed! Your OTP is {otp}"

    except Error as e:
        conn.rollback()  # Rollback in case of any error
        print(f"Error occurred: {str(e)}")
        return f"Failed to place order: {str(e)}"
    finally:
        cursor.close()

def is_grocery_item(store_id, item_name):
    cursor = conn.cursor()
    # Query to check if the item exists in the grocery table with a quantity greater than 0
    query = """
        SELECT COUNT(*) 
        FROM grocery 
        WHERE store_id = %s AND item_name = %s AND item_qty > 0
    """
    cursor.execute(query, (store_id, item_name))
    result = cursor.fetchone()
    cursor.close()
    return result[0] > 0


def assign_order_to_delivery_agent(order_id, delivery_agent_id):
    """
    This function updates the orders table, setting the iaAssigned field to 1
    and assigns the given delivery agent to the specified order.

    :param order_id: The ID of the order to be updated.
    :param delivery_agent_id: The ID of the delivery agent to assign to the order.
    """
    try:
        # Create a cursor object to interact with the database
        cursor = conn.cursor()

        # Query to update the order with the delivery agent ID and set iaAssigned to 1
        query = """
        UPDATE orders
        SET iaAssigned = 1, delivery_agent_id = %s
        WHERE order_id = %s AND iaAssigned = 0
        """
        cursor.execute(query, (delivery_agent_id, order_id))

        # Commit the transaction to make sure the changes are saved
        conn.commit()

        # Optionally return a success message or status
        return True

    except Exception as e:
        # Handle any errors (e.g., database connection issues)
        conn.rollback()  # Rollback in case of error
        print(f"Error assigning order: {e}")
        return False
    cursor.close()

def verify_OTP(order_id, otp_value):

    try:
        # Create a cursor object to interact with the database
        cursor = conn.cursor()

        # Query to update the order with the delivery agent ID and set iaAssigned to 1
        query = """
        SELECT OTP FROM ORDERS
        WHERE order_id = %s 
        """
        cursor.execute(query, ( order_id,))
        rows = cursor.fetchone()
        print("Type : ",order_id)
        otp_value = int(otp_value)
        if(otp_value == rows[0]):
            query = "UPDATE ORDERS set isDelivered = 1 where order_id = %s"
            cursor.execute(query,(order_id,))
            conn.commit()
            return True


        conn.commit()
        return False




    except Exception as e:
        # Handle any errors (e.g., database connection issues)
        conn.rollback()  # Rollback in case of error
        print(f"Error : Invalid OTP: {e}")
        return False
    cursor.close()


def submit_rating(orderId, rating, feedback, username):
    conn.commit()
    cursor = conn.cursor()

    try:
        query = "SELECT distinct store_id from cart where order_id = %s"
        cursor.execute(query, (orderId,))
        rows = cursor.fetchall()
        stores = []
        for row in rows:
            stores.append(row[0])
        for store in stores:
            query = "SELECT rating_num FROM rating WHERE store_id = %s AND username = %s"
            cursor.execute(query, (store,username,))
            existing_review = cursor.fetchall()
            rating_new = 0

            if existing_review:
                for row in existing_review:
                    rating_new = row[0]

                update_query = """
                UPDATE rating 
                SET rating_num = %s, feedback = %s 
                WHERE store_id = %s AND username = %s
                """
                rating_new = (rating_new + rating) / 2
                cursor.execute(update_query, (rating_new, feedback, store, username))
            else:
                insert_query = """
                INSERT INTO rating (store_id, username, rating_num, feedback)
                VALUES (%s, %s, %s, %s)
                """
                cursor.execute(insert_query, (store, username, rating, feedback))
        query = "delete from orders where order_id = %s"
        cursor.execute((query),(orderId,))
        conn.commit()
        return "Review submitted and average rating updated successfully!"

    except Error as e:
        conn.rollback()  # Rollback in case of an error
        print(f"Error occurred: {str(e)}")
        return f"Failed to submit review: {str(e)}"
    cursor.close()

def get_cart(username):
    cursor = conn.cursor()
    query = "SELECT * FROM cart where username = %s and is_order_placed = false"
    cursor.execute(query, (username,))
    rows = cursor.fetchall()
    store_id = []
    item = []
    price = []

    total = 0.0
    qty = []
    for row in rows:
        store_id.append(row[2])
        item.append(row[3])
        price.append("$" + str(row[4]))
        qty.append(row[5])
        total = total + (row[4] * row[5])
    cursor.close()
    return store_id, item, price, total, qty
