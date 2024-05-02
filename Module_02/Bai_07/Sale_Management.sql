-- Active: 1714535278653@@127.0.0.1@3306@sale_management
CREATE DATABASE Sale_Management DEFAULT CHARACTER
SET
    = 'utf8';

CREATE Table
    IF NOT EXISTS Customers (
        customer_id INT PRIMARY KEY AUTO_INCREMENT,
        first_name VARCHAR(50) NOT NULL,
        last_name VARCHAR(50) NOT NULL,
        email_address VARCHAR(50) NOT NULL,
        number_of_complaints int NOT NULL
    );

INSERT INTO
    customers (
        first_name,
        last_name,
        email_address,
        number_of_complaints
    )
VALUES
    (
        'John',
        'McKinley',
        'john.mackinley@365careers.com',
        0
    ),
    (
        'Elizabeth',
        'McFarlane',
        'e.mcfarlene@365careers.com',
        2
    ),
    (
        'Kevin',
        'Lawrence',
        'kevin.lawrence@365careers.com',
        1
    ),
    (
        'Catherine',
        'Winnfield',
        'c.winnfield@365careers.com',
        0
    );

CREATE Table
    IF NOT EXISTS Sales (
        purchase_number INT PRIMARY KEY AUTO_INCREMENT,
        date_of_purchase VARCHAR(50) NOT NULL,
        customer_id INT NOT NULL,
        item_code VARCHAR(50) NOT NULL
    );

INSERT INTO
    sales (date_of_purchase, customer_id, item_code)
VALUES
    ('03/09/2016', '1', 'A_1'),
    ('02/12/2016', '2', 'C_1'),
    ('15/04/2017', '3', 'D_1'),
    ('24/05/2017', '1', 'B_1'),
    ('25/05/2016', '4', 'B_1'),
    ('06/06/2016', '2', 'B_1'),
    ('10/06/2016', '4', 'A_1'),
    ('13/06/2016', '3', 'C_1'),
    ('20/07/2016', '1', 'A_1'),
    ('11/08/2016', '2', 'B_1');

CREATE Table
    IF NOT EXISTS Items (
        item_code VARCHAR(50) NOT NULL,
        item VARCHAR(50) NOT NULL,
        unit_price_usd INT NOT NULL,
        company_id INT NOT NULL,
        company VARCHAR(50) NOT NULL,
        headquarters_phone_number VARCHAR(50) NOT NULL
    );

INSERT INTO
    items (
        item_code,
        item,
        unit_price_usd,
        company_id,
        company,
        headquarters_phone_number
    )
VALUES
    (
        'A_1',
        'Lamp',
        20,
        1,
        'Company A',
        '+1 (202) 555-0196'
    ),
    (
        'A_2',
        'Desk',
        250,
        1,
        'Company A',
        '+1 (202) 555-0196'
    ),
    (
        'B_1',
        'Lamp',
        30,
        2,
        'Company B',
        '+1 (202) 555-0152'
    ),
    (
        'B_1',
        'Desk',
        350,
        2,
        'Company B',
        '+1 (202) 555-0152'
    ),
    (
        'C_1',
        'Chair',
        150,
        3,
        'Company C',
        '+1 (229) 853-9913'
    ),
    (
        'D_1',
        'Loudspeakers',
        400,
        4,
        'Company D',
        '+1 (618) 369-7392'
    );