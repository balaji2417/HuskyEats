from flask import Flask, render_template, redirect, url_for, request, flash, session, jsonify
import sql_queries as sq
from datetime import datetime
import re

app = Flask(__name__)

app.secret_key = 'husky_eats'
app.jinja_options = {
    'trim_blocks': False,
    'lstrip_blocks': False,
    'autoescape': False  # Disable autoescaping if it's affecting the output
}


@app.route('/')
def redirect_home():
    return redirect(url_for('login_home'))


@app.route('/home')
def login_home():
    return render_template('login.html')


@app.route('/check_valid_login', methods=['GET', 'POST'])
def valid_login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        isexist, user_name, categories = sq.check_valid_user(username, password)
        stores, items, prices, images, store_id = sq.get_top_stores()
    

        if isexist:
            session['username'] = username
            current_time = datetime.now()
            hour = current_time.hour
            if hour < 12:
                message = "Good Morning" + " " + user_name
            elif hour < 16:
                message = "Good Afternoon" + " " + user_name
            else:
                message = "Good Evening" + " " + user_name

            session['global_message'] = message
            zipped_data = zip(stores, items, prices, images, store_id)

            return render_template("user home.html", message=session['global_message'], categories=categories,
                                   zipped_data=zipped_data)

        else:
            return render_template('login.html', error="Invalid credentials. Please try again.")


@app.route('/home_display')
def home_display():
    if 'username' not in session:
        return redirect(url_for('login_home'))
    stores, items, prices, images, store_id = sq.get_top_stores()
    zipped_data = zip(stores, items, prices, images, store_id)
    return render_template("user home.html", message=session['global_message'],
                           zipped_data=zipped_data)


@app.route('/delivery')
def delivery_agent_login():
    return render_template('delivery_agent.html')

@app.route('/deliverypage')
def deliverypage():
    current_time = datetime.now()
    hour = current_time.hour
    user_name = sq.get_Delivery_name(session['delivery_username'])
    if hour < 12:
        message = "Good Morning" + " " + user_name
    elif hour < 16:
        message = "Good Afternoon" + " " + user_name
    else:

         message = "Good Evening" + " " + user_name

    session['global_message'] = message
    orders = sq.get_orders_from_database(session['delivery_username'])  # This should return a list of orders from your database
    return render_template('deliverypage.html', orders=orders,message = message)


@app.route('/logout')
def logout():
    session.pop('global_message')
    session.pop('username')
    return redirect(url_for('login_home'))


@app.route('/signup')
def signup():
    return render_template('signup.html')


@app.route('/cart')
def cart():
    store_id, item, price, total, qty = sq.get_cart(session['username'])
    zipped_data = zip(store_id, item, price, qty)
    building = sq.get_building()
    return render_template('cart.html', message=session['global_message'], building = building,zipped_data=zipped_data, total=total)


@app.route('/food')
def food():
    category = sq.getCategory()
    return render_template('new_page.html', message=session['global_message'], categories=category)


@app.route('/orders')
def orders():
    order_id, deliveryAgent, status, totalPrice= sq.get_orders()
    zipped_data = zip(order_id, deliveryAgent, status, totalPrice)
    order_data=sq.get_ordered_cart(order_id)

    return render_template('order.html', zipped_data=zipped_data,order_data = order_data, message=session['global_message'])


@app.route('/grocery')
def grocery():
    category = sq.get_grocery_category_list()
    return render_template('new_grocery_page.html', message=session['global_message'], categories=category)


@app.route('/categoryroute/<category_name>')
def category_page(category_name):
    category = sq.getCategory()
    stores, items, prices, images, store_ids = sq.get_menu_category(category_name)
    zipped_data = zip(stores, items, prices, images, store_ids)

    return render_template('new_page.html', zipped_data=zipped_data, message=session['global_message'],
                           categories=category, category_name=category_name)


@app.route('/category_grocery_route/<category_name>')
def category_grocery_page(category_name):
    category = sq.get_grocery_category_list()
    stores, items, prices, images, store_ids = sq.get_grocery_category(category_name)
    zipped_data = zip(stores, items, prices, images, store_ids)
    return render_template('new_grocery_page.html', zipped_data=zipped_data, message=session['global_message'],
                           categories=category, category_name=category_name)


@app.route('/register', methods=['GET', 'POST'])
def signup_user():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        refId = int(request.form['Id'])
        regexp_un = "[A-Z]*[a-z]+[0-9]*_*"
        regexp_pw = "[A-Z]+[a-z]+[0-9]*_*"
        if not (re.search(regexp_un, username)) or len(username) < 8 or len(username) > 15 or len(
                password) > 15 or not (re.search(regexp_pw, password)) or len(username) < 8:
            return render_template('signup.html', error="Incorrect Username and password combination")
        selected_value = request.form.get('userType')
        bool_check, message = sq.checkValidEntry(username, password, refId, selected_value)
        if bool_check:
            flash("User Created successfully", "success")
            return render_template('login.html')
        else:
            return render_template('signup.html', error=message)


@app.route('/valid_delivery', methods=['GET', 'POST'])
def valid_delivery():
    username = ""
    password = ""
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

    isexist = sq.check_delivery(username, password)  # Assuming this function checks credentials
    if isexist:
        session['delivery_username'] = username
        return redirect(url_for('deliverypage'))
    else:
        # Return to the login page with an error message if the credentials are invalid
        return render_template('delivery_agent.html', error="Invalid credentials. Please try again.")


@app.route('/add_to_cart_menu', methods=['POST'])
def add_to_cart_menu():
    data = request.get_json()

    # Extract item data from the POST request
    item = data.get('item')
    qty = data.get('quantity')
    price = data.get('price')
    store_id = data.get('store_id')
    sq.updateCart(session['username'], item, qty, price, store_id)
    return jsonify({'success': True, 'message': 'Item added to cart successfully!'})


# New route for updating the cart
@app.route('/update_cart', methods=['POST'])
def update_cart():
    username = session['username']
    item = request.form['item']
    store_id = request.form['store_id']
    action = request.form['action']  # 'add', 'decrease', or 'remove'

    # Handle the actions
    if action == 'add':
        qty_change = 1
    elif action == 'decrease':
        qty_change = -1
    elif action == 'remove':
        sq.deleteItemFromCart(username, item, store_id)
        return redirect(url_for('cart'))

    # Update the cart with new quantity
    sq.updateItemQuantityInCart(username, item, store_id, qty_change)

    # Redirect back to the cart page
    return redirect(url_for('cart'))


@app.route('/place_order', methods=['POST'])
def place_order():
    # Check if the user is logged in (assuming session management)
    if 'username' not in session:
        flash('You must be logged in to place an order', 'danger')
        return redirect(url_for('login'))  # Redirect to login page if not logged in

    # Get JSON data from the request body
    order_data = request.get_json()
    total_price = float(order_data.get('totalPrice'))  # Access totalPrice from the JSON body
    delivery_location = order_data.get('deliveryLocation')  # Access deliveryLocation from the JSON body

    # Check if both fields are provided
    if not total_price or not delivery_location:
        return jsonify({"error": "Missing totalPrice or deliveryLocation"}), 400

    # Call the place_order function from the database handler (sq)
    result = sq.place_order(session['username'], total_price, delivery_location)

    # Handle the result and provide feedback to the user
    if 'success' in result.lower():
        return jsonify({"message": "Order placed successfully"}), 200  # Return success response
    else:
        return jsonify({"error": result}), 400  # Return error response

@app.route('/submit_rating', methods=['POST'])
def submit_rating():
    print("Inside rating")
    # Check if the user is logged in (assuming session management)
    if 'username' not in session:
        flash('You must be logged in to place an order', 'danger')
        return redirect(url_for('login'))  # Redirect to login page if not logged in


    rating_data = request.get_json()
    rating = rating_data.get('rating')

    orderId = rating_data.get('orderId')
    print(orderId);
    feedback = rating_data.get('feedback')# Access deliveryLocation from the JSON body

    # Call the place_order function from the database handler (sq)
    result = sq.submit_rating(orderId,rating,feedback,session['username'])

    # Handle the result and provide feedback to the user
    if 'success' in result.lower():
        return jsonify({"message": result}), 200  # Return success response
    else:
        return jsonify({"error": result}), 400  # Return error response

@app.route('/assign_order', methods=['POST'])
def assign_order():
    try:
        data = request.get_json()  # Get JSON data from the request body
        order_id = data.get('order_id')
        delivery_agent_id = data.get('delivery_agent_id')

        # Validate that both order_id and delivery_agent_id are provided
        if not order_id or not delivery_agent_id:
            return jsonify({"error": "order_id and delivery_agent_id are required"}), 400

        # Call the function
        success = sq.assign_order_to_delivery_agent(order_id, delivery_agent_id)

        if success:
            return jsonify({"message": "Order assigned successfully"}), 200
        else:
            return jsonify({"error": "Failed to assign order"}), 500

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    



# main driver function
if __name__ == '__main__':
    app.run(debug=True)
