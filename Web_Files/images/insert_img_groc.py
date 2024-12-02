import os
import mysql.connector

# Connect to the database
connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="husky_eats"
)

cursor = connection.cursor(buffered=True)


# Function to convert image to binary data
def convert_to_binary(filename):
    with open(filename, 'rb') as file:
        return file.read()


try:
    # Define the base path for the images
    base_image_path = "E:/CS5200-DBMS/HuskyEats/Web_Files/grocery_images"

    # Iterate through the store subdirectories
    for store_id in os.listdir(base_image_path):
        store_folder_path = base_image_path + "/" + store_id

        # Only process directories (store folders)
        if os.path.isdir(store_folder_path):
            # Fetch the menu items sorted by food_name for this store_id
            sql = "SELECT item_name, store_id FROM grocery WHERE store_id = %s ORDER BY item_name"
            cursor.execute(sql, (store_id,))
            menu_items = cursor.fetchall()

            # Iterate over the menu items and attach the corresponding image
            for idx, menu_item in enumerate(menu_items):
                food_name, menu_id = menu_item

                image_filename = f"{food_name}.jpg"  # Assuming image filenames match food_name
                image_path = store_folder_path + "/" + image_filename
                print(image_path)

                if os.path.exists(image_path):  # Check if image exists
                    binary_data = convert_to_binary(image_path)
                    update_sql = "UPDATE grocery SET grocery_IMAGE = %s WHERE store_id = %s and item_name = %s"
                    cursor.execute(update_sql, (binary_data, menu_id, food_name))
                    print(f"Updated image for grocery: {food_name} in store {store_id}")
                else:
                    print(f"Image for {food_name} not found in store {store_id}")

    # Commit the changes to the database
    connection.commit()

except mysql.connector.Error as err:
    print(f"MySQL Error: {err}")
except Exception as e:
    print(f"Error: {e}")
finally:
    cursor.close()
    connection.close()
    print("Database connection closed")
