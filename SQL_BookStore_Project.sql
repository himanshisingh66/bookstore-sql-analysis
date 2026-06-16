CREATE DATABASE book_orders;

USE book_orders;

SELECT * FROM books;

SELECT * FROM customers;

SELECT * FROM orders;

-- 1 Retrieve all books in the "Fiction" genre
SELECT *
FROM books
WHERE genre="Fiction";


-- 2 Find books published after the year 1950
SELECT *
FROM books
WHERE published_year>1950;


-- 3 List all the customers from the Canada
SELECT * 
FROM customers 
WHERE country="Canada";


-- 4 Show orders placed in November 2023;
SELECT * 
FROM orders 
WHERE monthname(order_Date)="November" and year(order_date)=2023;
-- OR
SELECT * 
FROM orders 
WHERE order_date>="2023-11-01" AND order_date<= "2023-11-30";


-- 5 Retrieve the total stock of books available
SELECT SUM(stock) AS Total_Stock_Of_Books_Available
FROM books;


-- 6 Find the details of the most expensive book
SELECT *
FROM books
WHERE price = (SELECT MAX(price) FROM books);


-- 7 Show all customers who ordered more than 1 quantity of a book
SELECT * 
FROM orders
WHERE quantity>1;


-- 8 Retrieve all orders where the total amount exceeds $20
SELECT *
FROM orders
WHERE total_amount>20;


-- 9 List all genres available in the books table
SELECT DISTINCT genre
FROM books;


-- 10 Find all the book with the lowest stock
SELECT *
FROM books
WHERE stock = (SELECT MIN(stock) FROM books);

-- 11 Calculate the total revenue generated from all orders
SELECT SUM(total_amount) AS Total_Revenue
FROM orders;


-- ADVANCE QUESTIONS
-- 1 Retrieve the total number of books sold for each genre
SELECT b.genre,SUM(o.quantity) AS Total_Books_Sold
FROM books b INNER JOIN orders o
ON b.book_id=o.book_id
GROUP BY b.genre;


-- 2 Find the average price of books in the "Fantasy" genre
SELECT genre,AVG(price) AS Average_Price
FROM books
WHERE genre = "Fantasy";


-- 3 List customers who have placed at least 2 orders
SELECT o.customer_id,c.name
FROM customers c INNER JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY o.customer_id,c.name
HAVING COUNT(o.order_id)>1;


-- 4 Find the most frequently ordered book
SELECT o.book_id,b.title,count(order_id)
FROM books b INNER JOIN orders o
ON b.book_id = o.book_id
GROUP BY o.book_id,b.title
HAVING COUNT(order_id) = (SELECT DISTINCT COUNT(order_id) FROM orders GROUP BY book_id ORDER BY COUNT(order_id) DESC LIMIT 1);


-- 5 Show the top 3 most expensive books of 'Fantasy' Genre
SELECT *
FROM books
WHERE price IN (SELECT price 
FROM (SELECT DISTINCT price
FROM books
WHERE genre = "Fantasy"
ORDER BY price DESC 
LIMIT 3) i) AND genre = "Fantasy";


-- 6 Retrieve the total quantity of books sold by each author
SELECT b.author , SUM(o.quantity) AS Total_Books_Sold_By_Author
FROM books b INNER JOIN orders o
ON b.book_id = o.book_id
GROUP BY b.author;


-- 7 List the cities where customers who spend over $30 are located
SELECT DISTINCT c.city , total_amount
FROM customers c INNER JOIN orders o
ON c.customer_id = o.customer_id
WHERE total_amount>30;


-- 8 Find the customer who spent the most on orders
SELECT c.name , c.customer_id
FROM customers c
WHERE c.customer_id in (
SELECT o.customer_id
FROM orders o
GROUP BY o.customer_id
HAVING sum(o.total_amount) = (SELECT DISTINCT SUM(oi.total_amount)
FROM orders oi
GROUP BY oi.customer_id
ORDER BY SUM(oi.total_amount) DESC LIMIT 1));


-- 9 Calculate the stock remaining after fulfilling all orders (toughest question so far)
SELECT book_id , stock- Quantity_By_BookId AS Remaining_Stock FROM (SELECT b.book_id,coalesce(SUM(quantity),0) AS Quantity_By_BookId ,b.stock
FROM orders o RIGHT JOIN books b
ON o.book_id = b.book_id
GROUP BY b.book_id,b.stock) i;
