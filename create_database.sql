CREATE DATABASE IF  NOT EXISTS meal_subscription;
USE meal_subscription;

CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    registration_date DATE,
    age_group VARCHAR(10),
    region VARCHAR(20),
    city VARCHAR(50),
    state VARCHAR(50),
    acquisition_channel VARCHAR(50),
    referral_source VARCHAR(50),
    lifetime_value DECIMAL(10,2),
    engagement_score DECIMAL(5,2),
    churned TINYINT(1),
    churn_date DATE
);

CREATE TABLE subscriptions (
    subscription_id VARCHAR(15) PRIMARY KEY,
    customer_id VARCHAR(15),
    plan_type VARCHAR(20),
    start_date DATE,
    end_date DATE,
    price_per_week DECIMAL(10,2),
    is_active TINYINT(1),
    meals_per_week INT,
    auto_renewal TINYINT(1),
    payment_method VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE orders (
    order_id VARCHAR(15) PRIMARY KEY,
    subscription_id VARCHAR(15),
    order_date DATE,
    amount_spent DECIMAL(10,2),
    num_items INT,
    meal_type VARCHAR(20),
    delivery_status VARCHAR(20),
    special_instructions TEXT,
    rating DECIMAL(3,1),
    feedback TEXT,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

