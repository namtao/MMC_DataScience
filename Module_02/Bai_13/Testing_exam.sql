-- 1: Tạo bảng vớiràng buộc và kiểu dữ liệu. Sau đó, thêm ít nhất 5 bản ghi vào bảng.

DROP TABLE IF EXISTS `customer`;

CREATE TABLE `customer` (
    `customerId` int(11) NOT NULL AUTO_INCREMENT,
    `name` NVARCHAR (255) NOT NULL,
    `phone` NVARCHAR (255) NOT NULL,
    `email` NVARCHAR (255) NOT NULL,
    `address` NVARCHAR (255) NOT NULL,
    `note` NVARCHAR (255) NOT NULL,
    PRIMARY KEY (`customerId`)
);

DROP TABLE IF EXISTS `car`;

CREATE Table `car` (
    `carId` INT(11) NOT NULL AUTO_INCREMENT,
    `maker` ENUM('HONDA', 'TOYOTA', 'NISSAN'),
    `year` INT,
    `color` NVARCHAR (20),
    `note` NVARCHAR (20),
    PRIMARY KEY (`carId`)
)

DROP TABLE IF EXISTS `order`;

CREATE Table `order` (
    `orderId` INT(11) NOT NULL AUTO_INCREMENT,
    `customerId` INT(11) NOT NULL,
    `carID` INT(11),
    `amount` INT DEFAULT 1,
    `salePrice` INT,
    `orderDate` DATE,
    `deliveryDate` DATE,
    `deliveryAddress` NVARCHAR (100),
    `status` ENUM('0', '1', '2') DEFAULT '0',
    `note` NVARCHAR (255),
    PRIMARY KEY (`orderId`),
    FOREIGN KEY (`customerId`) REFERENCES `customer` (`customerId`),
    FOREIGN KEY (`carID`) REFERENCES `car` (`carId`)
);

INSERT INTO
    customer (
        customerId,
        name,
        phone,
        email,
        address,
        note
    )
VALUES (
        1,
        'John Doe',
        '123-456-7890',
        '[john.doe@example.com](mailto:john.doe@example.com)',
        '123 Main St',
        'Preferred customer'
    ),
    (
        2,
        'Jane Smith',
        '987-654-3210',
        '[jane.smith@example.com](mailto:jane.smith@example.com)',
        '456 Elm St',
        'New customer'
    ),
    (
        3,
        'Bob Johnson',
        '456-789-0123',
        '[bob.johnson@example.com](mailto:bob.johnson@example.com)',
        '789 Oak St',
        'Long-time customer'
    ),
    (
        4,
        'Alice Williams',
        '321-456-0987',
        '[alice.williams@example.com](mailto:alice.williams@example.com)',
        '321 Maple St',
        'Loyal customer'
    ),
    (
        5,
        'Charlie Brown',
        '654-321-0987',
        '[charlie.brown@example.com](mailto:charlie.brown@example.com)',
        '654 Pine St',
        'New customer'
    );

INSERT INTO
    car (
        carId,
        maker,
        `year`,
        color,
        note
    )
VALUES (
        1,
        'TOYOTA',
        2020,
        'Red',
        'New car'
    ),
    (
        2,
        'HONDA',
        2019,
        'Blue',
        'Used car'
    ),
    (
        3,
        'NISSAN',
        2018,
        'Silver',
        'Leased car'
    ),
    (
        4,
        'HONDA',
        2017,
        'Black',
        'Rental car'
    ),
    (
        5,
        'HONDA',
        2021,
        'White',
        'New car'
    );

INSERT INTO
    `order` (
        orderId,
        customerId,
        carID,
        amount,
        salePrice,
        orderDate,
        deliveryDate,
        deliveryAddress,
        `status`,
        note
    )
VALUES (
        1,
        1,
        1,
        1,
        30000,
        '2024-01-01',
        '2024-01-05',
        '123 Main St',
        '0',
        'New order'
    ),
    (
        2,
        2,
        3,
        1,
        20000,
        '2024-01-02',
        '2024-01-06',
        '456 Elm St',
        '1',
        'Pending order'
    ),
    (
        3,
        2,
        3,
        1,
        25000,
        '2024-01-03',
        '2024-01-07',
        '789 Oak St',
        '2',
        'Completed order'
    ),
    (
        4,
        4,
        3,
        1,
        22000,
        '2024-01-04',
        '2024-01-08',
        '321 Maple St',
        '2',
        'Completed order'
    ),
    (
        5,
        2,
        3,
        1,
        35000,
        '2024-01-05',
        '2024-01-09',
        '654 Pine St',
        '0',
        'New order'
    );

-- 2: Viết lệnh lấy ra thông tin của khách hàng: tên, số lượng oto khách hàng đã mua và sắp sếp tăng dần theo số lượng oto đã mua.

SELECT maker, COUNT(maker)
FROM `order` o
    JOIN car ca ON o.`carID` = ca.`carId`
GROUP BY
    maker;

-- 3: Viết hàm (không có parameter) trả về tên hãng sản xuất đã bán được nhiều oto nhất trong năm nay.

DELIMITER $$

CREATE PROCEDURE fn_GetMaxCar()

BEGIN
SELECT maker, COUNT(maker) as 'sl'
FROM `order` o
    JOIN car ca ON o.`carID` = ca.`carId`
WHERE
    YEAR(`deliveryDate`) = YEAR(NOW())
GROUP BY
    maker
HAVING
    COUNT(maker) = (
        SELECT MAX(a.hang)
        FROM (
                SELECT maker, COUNT(maker) as 'hang'
                FROM `order` o
                    JOIN car ca ON o.`carID` = ca.`carId`
                WHERE
                    YEAR(`deliveryDate`) = YEAR(NOW())
                GROUP BY
                    maker
            ) a
    );

END $$

DELIMITER;

CALL `fn_GetMaxCar` ()
-- 4: Viết 1 thủ tục (không có parameter) để xóa các đơn hàng đã bị hủy của những năm trước. In ra số lượng bản ghi đã bị xóa.

DELIMITER $$

CREATE PROCEDURE p_DeliveryCancer()

BEGIN

DECLARE count INT ;
SET count = (SELECT count(*)
FROM `order` 
WHERE
    YEAR(`deliveryDate`) < YEAR(NOW()));
    
DELETE FROM `order` 
WHERE
    YEAR(`deliveryDate`) < YEAR(NOW());

END $$

DELIMITER;

-- 5: Viết 1 thủ tục (có CustomerID parameter) để in ra thông tin của các đơn hàng đã đặt hàng bao gồm: tên của khách hàng, mã đơn hàng, số lượng oto và tên hãng sản xuất.

DELIMITER $$

CREATE PROCEDURE p_GetNameCarDelivery(customerId INT)

BEGIN
SELECT `name`, o.`orderId`, maker, amount
FROM
    `order` o
    LEFT JOIN customer cu ON o.`customerId` = cu.`customerId`
    RIGHT JOIN car ca on ca.`carId` = o.`carID`
WHERE
    cu.`customerId` = customerId;
END $$

DELIMITER;

CALL p_GetNameCarDelivery (1);

-- 6: Viết trigger để tránh trường hợp người dụng nhập thông tin không hợp lệ vào database (DeliveryDate < OrderDate + 15).
DELIMITER $$

CREATE TRIGGER `tr_DeliveryDate` BEFORE INSERT ON `order` FOR EACH ROW
BEGIN
 IF NEW.`deliveryDate` < DATE_ADD(NEW.`orderDate`, INTERVAL 15 DAY) THEN
 SIGNAL SQLSTATE '45000'
 SET MESSAGE_TEXT = 'Delivery date must be greater than order date plus 15 days.';
 END IF;
 END $$

DELIMITER;