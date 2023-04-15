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
    
    The tables product_orders and orders have a many-to-one relationship, since an order can be associated with more than one product_order.

* Identify a pair of tables that have a one-to-one relationship. Explain why they have such a relation.
  
    The tables restaurants and addresses have a one-to-one relationship, since an address can appear only a single time in the restaurants table.

* Identify a many-to-many relationship in the diagram. Which tables are involved and why?
  
    The tables orders and products have an indirect many-to-many relationship through the product_orders table. Since an order can have many product_orders and a product can have many product_orders, that means a product will be connect to many orders, and vice-versa.