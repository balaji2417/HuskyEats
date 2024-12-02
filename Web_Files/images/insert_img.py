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
    base_image_path = "E:/CS5200-DBMS/HuskyEats/Web_Files/menu_images"

    # Iterate through the store subdirectories
    for store_id in os.listdir(base_image_path):
        store_folder_path = base_image_path+"/"+store_id

        # Only process directories (store folders)
        if os.path.isdir(store_folder_path):
            # Fetch the menu items sorted by food_name for this store_id
            sql = "SELECT food_name, store_id FROM MENU WHERE store_id = %s ORDER BY food_name"
            cursor.execute(sql, (store_id,))
            menu_items = cursor.fetchall()

            # Iterate over the menu items and attach the corresponding image
            for idx, menu_item in enumerate(menu_items):
                food_name, menu_id = menu_item
                food_name_new = food_name.split(" ")
                food_update = food_name
                if(len(food_name_new) >1):
                    food_name = ""
                    count = 1
                    for i in food_name_new:
                        food_name = food_name+i.lower()
                        if(count>=len(food_name_new)):
                            continue
                        food_name+="_"
                        count+=1

                image_filename = f"{food_name}.jpg"  # Assuming image filenames match food_name
                image_path = store_folder_path+"/"+image_filename
                print(image_path)

                if os.path.exists(image_path):  # Check if image exists
                    binary_data = convert_to_binary(image_path)
                    update_sql = "UPDATE MENU SET FOOD_IMAGE = %s WHERE store_id = %s and food_name = %s"
                    cursor.execute(update_sql, (binary_data, menu_id,food_update))
                    print(f"Updated image for food: {food_name} in store {store_id}")
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
