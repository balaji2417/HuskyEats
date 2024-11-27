import mysql.connector
from flask import Flask, render_template, redirect, url_for, request
from datetime import datetime
# Flask constructor takes the name of
# current module (__name__) as argument.
app = Flask(__name__)
conn = mysql.connector.connect(
    host="localhost",  # Change to your host, e.g., "127.0.0.1" or "your_host"
    user="root",  # Replace with your MySQL username
    password="Sqlafrah@123",  # Replace with your MySQL password
    database="husky_eats"  # Replace with the database name
)
if conn.is_connected():
    print("Connection to MySQL database established successfully.")


def check_delivery(username, password):
    cursor = conn.cursor()
    query = "SELECT username FROM customer WHERE username = %s AND user_password = %s"
    cursor.execute(query, (username, password))
    rows = cursor.fetchall()
    return len(rows) > 0


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

        cursor = conn.cursor()
        query = "SELECT username, FROM customer WHERE username = %s AND user_password = %s"
        cursor.execute(query, (username, password))
        rows = cursor.fetchall()
        if (len(rows) > 0):
            return render_template("home_user.html", message="Good Morning Balaji")
        else:
            return render_template('login.html', error="Invalid credentials. Please try again.")


@app.route('/delivery')
def delivery_agent_login():
    return render_template('delivery_agent.html')


@app.route('/signup')
def signup():
    return render_template('signup.html')


@app.route('/valid_delivery', methods=['GET', 'POST'])
def valid_delivery():
    username = ""
    password = ""
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
    isexist = check_delivery(username, password)
    if isexist:
        return render_template('delivery_agent.html')
    else:
        return render_template('delivery_agent.html', error="Invalid credentials. Please try again.")


# main driver function
if __name__ == '__main__':
    app.run()
