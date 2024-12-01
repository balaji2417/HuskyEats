
from flask import Flask, render_template, redirect, url_for, request, flash, session
import sql_queries as sq
from datetime import datetime
import re
app = Flask(__name__)
global_message = ""


app.config['SECRET_KEY'] = 'husky_eats'



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



        isexist,user_name,categories = sq.check_valid_user(username, password)

        if (isexist):
            #images = sq.get_images()
            current_time = datetime.now()
            hour = current_time.hour
            if (hour > 0 and hour < 12):
             message = "Good Morning"+" "+user_name
            if (hour >= 12 and hour < 16):
              message = "Good Afternoon"+" "+user_name
            if (hour >= 16 and hour < 23):
              message = "Good Evening"+" "+user_name
            global_message = message
            return render_template("new_page.html", message=global_message,categories = categories)

        else:
            return render_template('login.html', error="Invalid credentials. Please try again.")


@app.route('/delivery')
def delivery_agent_login():
    return render_template('delivery_agent.html')


@app.route('/logout')
def logout():
    session.clear()
    return render_template('login.html')


@app.route('/signup')
def signup():
    return render_template('signup.html')

@app.route('/categoryroute')
def category_page(category_name):
    sq.getCategory()
    return render_template('new_user.html',message = global_message,categories = category)

@app.route('/register', methods=['GET', 'POST'])
def signup_user():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        refId = int(request.form['Id'])
        regexp_un = "[A-Z]*[a-z]+[0-9]*_*"
        regexp_pw = "[A-Z]+[a-z]+[0-9]*_*"
        if not (re.search(regexp_un, username)) or len(username) <8 or len(username) >15 or  len(password) >15 or not (re.search(regexp_pw, password)) or len(username) < 8:
            return render_template('signup.html', error="Incorrect Username and password combination")
        selected_value = request.form.get('userType')
        bool_check, message = sq.checkValidEntry(username, password, refId, selected_value)
        if (bool_check):
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

    isexist = sq.check_delivery(username, password)
    if isexist:
        return "Hello"
    else:
        return render_template('delivery_agent.html', error="Invalid credentials. Please try again.")


# main driver function
if __name__ == '__main__':
    app.run()
