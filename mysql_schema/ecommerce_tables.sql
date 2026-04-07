CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

DROP TABLE IF EXISTS user_info;
CREATE TABLE user_info (
    user_id BIGINT PRIMARY KEY,
    username VARCHAR(50),
    phone VARCHAR(20) UNIQUE,
    gender VARCHAR(10),
    birthday DATE,
    city VARCHAR(50),
    register_time DATETIME,
    user_level VARCHAR(20),
    user_status VARCHAR(20),
    create_time DATETIME,
    update_time DATETIME
);

DROP TABLE IF EXISTS product_info;
CREATE TABLE product_info (
    product_id BIGINT PRIMARY KEY,
    product_name VARCHAR(100),
    category_id BIGINT,
    brand_name VARCHAR(50),
    price DECIMAL(16,2),
    product_status VARCHAR(20),
    create_time DATETIME,
    update_time DATETIME
);

DROP TABLE IF EXISTS category_info;
CREATE TABLE category_info (
    category_id BIGINT PRIMARY KEY,
    category_name VARCHAR(50),
    parent_category_id BIGINT,
    create_time DATETIME,
    update_time DATETIME
);

DROP TABLE IF EXISTS order_info;
CREATE TABLE order_info (
    order_id BIGINT PRIMARY KEY,
    user_id BIGINT,
    order_status VARCHAR(20),
    total_amount DECIMAL(16,2),
    pay_amount DECIMAL(16,2),
    order_time DATETIME,
    pay_time DATETIME,
    province VARCHAR(50),
    city VARCHAR(50),
    create_time DATETIME,
    update_time DATETIME
);

DROP TABLE IF EXISTS order_detail;
CREATE TABLE order_detail (
    order_detail_id BIGINT PRIMARY KEY,
    order_id BIGINT,
    product_id BIGINT,
    product_num INT,
    product_price DECIMAL(16,2),
    original_amount DECIMAL(16,2),
    create_time DATETIME
);

DROP TABLE IF EXISTS payment_info;
CREATE TABLE payment_info (
    payment_id BIGINT PRIMARY KEY,
    order_id BIGINT,
    user_id BIGINT,
    payment_type VARCHAR(20),
    payment_status VARCHAR(20),
    payment_amount DECIMAL(16,2),
    payment_time DATETIME,
    create_time DATETIME
);

DROP TABLE IF EXISTS user_action_log;
CREATE TABLE user_action_log (
    action_id BIGINT PRIMARY KEY,
    user_id BIGINT,
    product_id BIGINT,
    action_type VARCHAR(20),
    action_time DATETIME
);