import mysql.connector

connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="husky_eats"
)

cursor = connection.cursor(buffered=True)


def convert_to_binary(filename):
    with open(filename, 'rb') as file:
        return file.read()


try:
    image_path = "E:/CS5200-DBMS/HuskyEats/Web_Files/menu_images/menu_images/1/caesar_salad.jpg"
    binary_data = convert_to_binary(image_path)
    sql = "UPDATE MENU SET FOOD_IMAGE = %s WHERE store_id = %s and food_name = %s"
    cursor.execute(sql, (binary_data, 1, "Caesar Salad"))
    connection.commit()

except mysql.connector.Error as err:
    print(f"MySQL Error: {err}")
finally:
    cursor.close()
    connection.close()
    print("Database connection closed")
