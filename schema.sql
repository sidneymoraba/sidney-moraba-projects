-- Coffee Shop Database (MySQL 8+)
-- Run first: creates the database, tables, constraints, indexes, views and a stock trigger.

CREATE DATABASE IF NOT EXISTS coffee_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE coffee_shop;

CREATE TABLE customers (
  customer_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  full_name     VARCHAR(100) NOT NULL,
  email         VARCHAR(120) NOT NULL UNIQUE,
  phone         VARCHAR(20),
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
  category_id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name          VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE products (
  product_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  category_id   INT UNSIGNED NOT NULL,
  name          VARCHAR(80) NOT NULL,
  price         DECIMAL(8,2) NOT NULL CHECK (price > 0),
  stock_qty     INT NOT NULL DEFAULT 0 CHECK (stock_qty >= 0),
  is_active     BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES categories(category_id),
  INDEX idx_products_category (category_id)
);

CREATE TABLE orders (
  order_id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  customer_id   INT UNSIGNED NOT NULL,
  status        ENUM('pending','paid','preparing','completed','cancelled') NOT NULL DEFAULT 'pending',
  ordered_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  INDEX idx_orders_customer (customer_id),
  INDEX idx_orders_date (ordered_at)
);

CREATE TABLE order_items (
  order_id      INT UNSIGNED NOT NULL,
  product_id    INT UNSIGNED NOT NULL,
  quantity      INT NOT NULL CHECK (quantity > 0),
  unit_price    DECIMAL(8,2) NOT NULL CHECK (unit_price > 0),   -- price at time of sale
  PRIMARY KEY (order_id, product_id),
  CONSTRAINT fk_item_order   FOREIGN KEY (order_id)   REFERENCES orders(order_id) ON DELETE CASCADE,
  CONSTRAINT fk_item_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
  payment_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  order_id      INT UNSIGNED NOT NULL,
  method        ENUM('card','eft','cash') NOT NULL,
  amount        DECIMAL(9,2) NOT NULL CHECK (amount > 0),
  paid_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
  INDEX idx_payments_order (order_id)
);

-- Order totals, calculated from the items
CREATE VIEW v_order_totals AS
SELECT o.order_id, o.customer_id, o.status, o.ordered_at,
       SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.customer_id, o.status, o.ordered_at;

-- Daily sales for paid and completed orders
CREATE VIEW v_daily_sales AS
SELECT DATE(ordered_at) AS sale_date, COUNT(*) AS orders, SUM(order_total) AS revenue
FROM v_order_totals
WHERE status IN ('paid','preparing','completed')
GROUP BY DATE(ordered_at);

-- Reduce stock automatically whenever an item is sold
DELIMITER //
CREATE TRIGGER trg_reduce_stock AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
  UPDATE products SET stock_qty = stock_qty - NEW.quantity WHERE product_id = NEW.product_id;
END//
DELIMITER ;
