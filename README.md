# README

## Research
* What is SQL?
  
    SQL stands for Structured Query Language. It is a programming language used to manipulate relational databases. These are databases that store data in separate tables, which can be joined together by fields known as foreign keys.

* What is the main difference between SQLite and MySQL?

    SQLite is a lightweight, portables, file-based database management system, while MySQL is a client-server database management system, supporting more advanced data manipulation features, and a more sophisticated locking mechanism.

    Locking mechanism refers to the way a database management system handles concurrent access. 


* What are Primary and Foreign Key? Give an example for each.

    A primary key is a column containing a unique value for each record, serving as an identifier, while a foreign key is one or more columns in a table that refer to the primary key of another table.

    In the Users table, the primary key could be the Email column, since no person can have the same email of another person. In the same table, a column named Position could accept only values coming from the table Positions, where all the positions in a company are listed. In this scenario, the Position column in the Users table is a foreign key.

* What are the different relationship types that can be found in a relational database? Give an example for each type.
  - One-to-one: each record in a table is associated with only one record in another table, and vice versa
  - One-to-many: each record in one table is associated with one or more records in another table, but each record in the other table is associated with only one record in the first table
  - Many-to-many: each record in one table is associated with one or more records in another table, and vice versa

## Entity Relationship Diagram (ERD) Analysis
* Identify a pair of tables that have a many-to-one relationship. Explain why they have such a relation.
* Identify a pair of tables that have a one-to-one relationship. Explain why they have such a relation.
* Identify a many-to-many relationship in the diagram. Which tables are involved and why?

addresses
- associates with employees and customers in a one-to-many relationship, and with restaurants in a one-to-one relationship
- one address can be associated with more than one employee/restaurant/customer,
but an employee/restaurant/customer can be associated with only one address
- has_many: employees
- has_many: customers
- has_one: restaurant

users
- associates with employees and customers in a one-to-one relationship, and with restaurants in a one-to-many relationship
- a user can be associated with only one employee/customer, and an
employee/customer can be associated with only one user
- a user can be associated with more than on restaurant, but a restaurant can be associated with only one user
- has_one: employee
- has_one: customer
- has_many: restaurants

employees
- associates with addresses in a one-to-many relationship, and with users in a one-to-one relationship

restaurants
- associates with users, addresses, products and orders in a one-to-many relationship
- a restaurant can have many products, but a product can have only one restaurant
- a restaurant can have many orders, but an order can have only one restaurant
- user_id? user responsible for the restaurant? a user can be responsible for more than
one restaurant?

customers
- associates with users in a one-to-one relationship, and with addresses and orders in a one-to-many relationship
- one customer can be linked to many orders, but an order can be linked to exactly one customer

products
- associates with restaurants and product_orders in a one-to-many relationship
- a product can be linked to many product_orders, but a product_order can be linked to exactly one product

orders
- associates with restaurants, customers, product_orders and order_statuses in a one-to-many relationship
- an order can have many product_orders, but a product_order can have only one product related to it
- an order can be associated with only one order_status, whereas an order_status can be associated with many orders
