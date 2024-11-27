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
    image_path = "img1.jpg"
    binary_data = convert_to_binary(image_path)
    sql = "UPDATE MENU SET IMAGE_FOOD = %s WHERE store_id = %s"
    for i in range(1, 16):
        if i == 5:
            continue
        cursor.execute(sql, (binary_data, i))

    # Fetch image data
    sql1 = "SELECT image_food FROM MENU WHERE store_id = %s"
    cursor.execute(sql1, (1,))
    result = cursor.fetchone()

    if result and result[0]:
        with open("output_image.jpg", 'wb') as file:
            file.write(result[0])
        print("Image retrieved and saved as 'output_image.jpg'")
    else:
        print("No image found for store_id = 1")

except mysql.connector.Error as err:
    print(f"MySQL Error: {err}")
finally:
    cursor.close()
    connection.close()
    print("Database connection closed")
