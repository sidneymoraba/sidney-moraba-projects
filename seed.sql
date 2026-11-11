-- Sample data. Run after schema.sql.
USE coffee_shop;

INSERT INTO customers (full_name, email, phone) VALUES
 ('Thandi Mokoena','thandi@example.com','0821234567'),
 ('Pieter Naidoo','pieter@example.com','0839876543'),
 ('Lerato Dlamini','lerato@example.com',NULL);

INSERT INTO categories (name) VALUES ('Hot drinks'),('Cold drinks'),('Pastries');

INSERT INTO products (category_id, name, price, stock_qty) VALUES
 (1,'Cappuccino',38.00,100),(1,'Flat white',40.00,100),(1,'Hot chocolate',35.00,80),
 (2,'Iced latte',45.00,60),(3,'Butter croissant',28.00,40),(3,'Blueberry muffin',32.00,30);

INSERT INTO orders (customer_id, status, ordered_at) VALUES
 (1,'completed','2026-11-09 08:15:00'),(2,'completed','2026-11-09 12:40:00'),
 (1,'paid','2026-11-10 09:05:00'),(3,'pending','2026-11-10 10:30:00');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
 (1,1,2,38.00),(1,5,1,28.00),(2,4,1,45.00),(2,6,2,32.00),(3,2,1,40.00),(4,3,1,35.00);

INSERT INTO payments (order_id, method, amount, paid_at) VALUES
 (1,'card',104.00,'2026-11-09 08:16:00'),(2,'cash',109.00,'2026-11-09 12:41:00'),(3,'eft',40.00,'2026-11-10 09:06:00');
