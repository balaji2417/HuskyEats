create database if not exists Husky_eats;
use Husky_Eats;

create table customer (
						username varchar(50) primary key,
                        user_password varchar(66),
                        user_type ENUM ('Faculty','Student'),
                        Reference_Id int);

create table delivery_agent(
							 Delivery_agent_id varchar(50) primary key,
                             first_name varchar(100),
                             last_name varchar(100),
                             DOB date NOT NULL,
                             Gender ENUM ('Male','Female'),
                             Phone_no int,
                             Availability_time time,
                             Availability BOOLEAN DEFAULT TRUE); -- Write a trigger for dob for 18 years check.
                        
-- Student's table NEU which is referenced for husky eats user creation.
create table student (
					  NUID int primary key,
                      First_Name varchar(255),
                      Last_Name varchar(255),
                      DOB date,
                      Email_Address varchar(175),
                      Street_name varchar(100),
                      City varchar(150),
                      Zipcode int,
                      username varchar(50),
                      CONSTRAINT student_username_fk_1 FOREIGN KEY (username) REFERENCES customer(username)
                      ON UPDATE CASCADE ON DELETE CASCADE);
 
-- NEU Employee table which is referenced for husky eats user creation.
create table NEU_Employee (
							Faculty_ID int primary key,
                            First_name varchar(255),
                            Last_name  varchar(255),
                            DOB date,
                            Email varchar(175),
                            Gender ENUM ('Male','Female'),
                            College_Name varchar(100),
                            username varchar(50),
                           CONSTRAINT faculty_username_fk_1 FOREIGN KEY (username) REFERENCES customer(username)
						ON UPDATE CASCADE ON DELETE CASCADE);
                            

-- Sub class of the parent class NEU_Employee (Teaching staff has eduational qualifications and the department name they are associated with).
create table teaching_staff (
								Faculty_id int,
                                Educational_Qualifications varchar(10),
                                Department_name varchar(10),
                                PRIMARY KEY (Faculty_id,Educational_Qualifications),
                                CONSTRAINT Teaching_Staff_FK_1 FOREIGN KEY (Faculty_id) REFERENCES NEU_Employee (Faculty_ID)
                                ON UPDATE CASCADE ON DELETE CASCADE);
                                

-- Sub class of the parent class NEU_Employee
create table Admin_Faculty(
							Faculty_id int primary key,
                            Admin_Department_name varchar(30),
                            CONSTRAINT Admin_Faculty_FK FOREIGN KEY (Faculty_Id) REFERENCES NEU_Employee (Faculty_ID) 
                            ON UPDATE CASCADE ON DELETE CASCADE);


create table building (
						Building_id int primary key,
                        Building_name varchar(100),
                        store_capacity int);
                        
create table store (
					store_id int primary key,
                    store_name varchar(50),
                    start_time time,
                    end_time time,
                    Building_id int,
                    CONSTRAINT store_building_fk FOREIGN KEY (Building_id) REFERENCES building(Building_id)
                    ON UPDATE RESTRICT ON DELETE RESTRICT);

create table menu (
					store_id int,
                    Food_name varchar(100),
                    Food_cuisine varchar(100),
                    Price float,
                    Availability ENUM ('Yes','No'),
                    PRIMARY KEY(store_id,Food_name),
                    CONSTRAINT store_menu_fk FOREIGN KEY (store_id) REFERENCES store(store_id)
                    ON UPDATE CASCADE ON DELETE CASCADE); -- After a time write an event to set it to No Automatically.


create table Grocery (
						store_id int,
						item_name varchar(100),
                        item_price float,
                        item_qty int,
                        PRIMARY KEY(store_id,item_name),
						CONSTRAINT store_grocery_fk FOREIGN KEY (store_id) REFERENCES store(store_id)
                         ON UPDATE CASCADE ON DELETE CASCADE);
                         
create table Category (
						Category_id int primary key,
                        Category_name varchar(100),
                        Category_Belonging ENUM ('Menu','Grocery')
                        );

create table store_category(
							Category_id int,
                            store_id int,
                            item_name varchar(100),
                            CONSTRAINT groc_cat_fk_store FOREIGN KEY (store_id,item_name) REFERENCES Grocery (store_id,item_name)
						    ON UPDATE CASCADE ON DELETE CASCADE,
                            CONSTRAINT groc_cat_fk FOREIGN KEY (Category_id) REFERENCES Category(Category_id)
                            ON UPDATE CASCADE ON DELETE CASCADE);

create table menu_category(
							Category_id int,
                            store_id int,
                            Food_name varchar(100),
                            CONSTRAINT menu_cat_fk_store FOREIGN KEY (store_id,Food_name) REFERENCES menu (store_id,Food_name)
						    ON UPDATE CASCADE ON DELETE CASCADE,
                            CONSTRAINT menu_cat_fk FOREIGN KEY (Category_id) REFERENCES Category(Category_id)
                            ON UPDATE CASCADE ON DELETE CASCADE);


create table cart(
					Cart_id INT PRIMARY KEY AUTO_INCREMENT,
					username varchar(50),
                    store_id int,
					items_name varchar(100),
                    items_price float,
                    items_qty int,
                    is_order_placed BOOLEAN DEFAULT FALSE,
                    CONSTRAINT cart_user_fk FOREIGN KEY(username) REFERENCES customer(username)
                    ON UPDATE CASCADE ON DELETE CASCADE
                    );


CREATE TABLE Shops (
    Store_id INT,
    Username VARCHAR(50),
    PRIMARY KEY (Store_id, Username),
    FOREIGN KEY (Store_id) REFERENCES Store(Store_id),
    FOREIGN KEY (Username) REFERENCES Customer(Username)
);
                    

create table orders(
					order_id int primary key auto_increment,
                    cart_id int,
                    username varchar(50),
                    Delivery_agent_id varchar(50),
                    Total_amount float,
                    delivery_location varchar(100),
                    iaAssigned BOOLEAN default FALSE,
                    isDelivered BOOLEAN default FALSE,
                    OTP int,
                    CONSTRAINT orders_cart_orders_fk FOREIGN KEY (cart_id) REFERENCES cart(cart_id)
                    ON UPDATE CASCADE ON DELETE CASCADE,
                    CONSTRAINT user_cart_orders_fk FOREIGN KEY (username) REFERENCES customer(username)
                    ON UPDATE CASCADE ON DELETE CASCADE,
                    CONSTRAINT delivery_cart_orders_fk FOREIGN KEY (Delivery_agent_id) REFERENCES Delivery_agent(Delivery_Agent_id)
                    ON UPDATE CASCADE ON DELETE CASCADE);-- Write an event to set it to is assigned as false 
                    
create table rating (
						rating_num int,
                        store_id int primary key,
                        feedback varchar(500),
                        username varchar(50),
						CONSTRAINT rating_username_fk FOREIGN KEY (username) REFERENCES customer(username) ON UPDATE CASCADE ON DELETE CASCADE,
                        CONSTRAINT rating_store_fk FOREIGN KEY (store_id) REFERENCES store(store_id) ON UPDATE CASCADE ON DELETE CASCADE);
                    
                    

                            


                        
                        
						