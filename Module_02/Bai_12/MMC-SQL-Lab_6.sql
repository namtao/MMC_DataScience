-- Active: 1714535278653@@127.0.0.1@3306@testing_system_db
--Question 1: Tạo store để người dùng nhập vào tên phòng ban và in ra tất cả các account thuộc phòng ban đó
DELIMITER $$

CREATE PROCEDURE sp_getAccountByDepartmentName(IN DepartmentName NVARCHAR(50))
BEGIN
SELECT a.*
FROM `account` a
    JOIN department d ON a.`DepartmentID` = d.`DepartmentID`
WHERE
    `DepartmentName` =  DepartmentName;
END$$

DELIMITER;

CALL `sp_getAccountByDepartmentName` ('Sale');

-- Question 2: Tạo store để in ra số lượng account trong mỗi group
DROP PROCEDURE IF EXISTS `sp_getCountAccountInGroup`;

DELIMITER $$

CREATE PROCEDURE sp_getCountAccountInGroup(IN grId INT)
BEGIN
SELECT
    g.`GroupID`,
    COUNT(ga.`GroupID`) as 'SL'
FROM
    groupaccount ga
    LEFT JOIN `account` a on a.`AccountID` = ga.`AccountID`
    RIGHT JOIN `group` g on g.`GroupID` = ga.`GroupID`
GROUP BY
    g.`GroupID`
HAVING g.`GroupID` = grId;
END$$

DELIMITER;

CALL `sp_getCountAccountInGroup` (1);

--Question 3: Tạo store để thống kê mỗi type question có bao nhiêu question được tạo trong tháng hiện tại
WITH
    a AS (
        SELECT *
        FROM question
        WHERE
            DATE(`CreateDate`) = DATE('2020-04-05')
    )
SELECT `TypeID`, COUNT(`TypeID`)
FROM a
GROUP BY
    `TypeID`;

-- Question 4: Tạo store để trả ra id của type question có nhiều câu hỏi nhất
SELECT `TypeID`
FROM question
GROUP BY
    `TypeID`
HAVING
    COUNT(`TypeID`) = (
        SELECT MAX(a.sl)
        FROM (
                SELECT `TypeID`, COUNT(`TypeID`) as sl
                FROM question
                GROUP BY
                    `TypeID`
            ) a
    );

-- Question 5: Sử dụng store ở question 4 để tìm ra tên của type question
SELECT `TypeName`
FROM `typequestion`
WHERE
    `TypeID` = (
        SELECT `TypeID`
        FROM question
        GROUP BY
            `TypeID`
        HAVING
            COUNT(`TypeID`) = (
                SELECT MAX(a.sl)
                FROM (
                        SELECT `TypeID`, COUNT(`TypeID`) as sl
                        FROM question
                        GROUP BY
                            `TypeID`
                    ) a
            )
    );
-- Question 6: Viết 1 store cho phép người dùng nhập vào 1 chuỗi và trả về group có tên chứa chuỗi của người dùng nhập vào hoặc trả về user có username chứa chuỗi của người dùng nhập vào
SELECT `GroupName`
FROM `group`
UNION
SELECT `Username`
FROM `account`
WHERE
    `Username` LIKE CONCAT('%', 'Sale', '%');

-- Question 7: Viết 1 store cho phép người dùng nhập vào thông tin fullName, email và trong store sẽ tự động gán: username sẽ giống email nhưng bỏ phần @..mail đi, positionID: sẽ có default là developer, departmentID: sẽ được cho vào 1 phòng chờ. Sau đó in ra kết quả tạo thành công

-- Question 8: Viết 1 store cho phép người dùng nhập vào Essay hoặc Multiple-Choice để thống kê câu hỏi essay hoặc multiple-choice nào có content dài nhất
SELECT `TypeName`, COUNT(`TypeName`)
FROM question q
    JOIN typequestion tq ON q.`TypeID` = tq.`TypeID`
GROUP BY
    `TypeName`
HAVING
    `TypeName` = 'Essay';
-- Question 9: Viết 1 store cho phép người dùng xóa exam dựa vào ID
SELECT * FROM exam WHERE `ExamID` = 1;

-- Question 10: Tìm ra các exam được tạo từ 3 năm trước và xóa các exam đó đi (sử dụng store ở câu 9 để xóa) Sau đó in số lượng record đã remove từ các table liên quan trong khi removing

-- Question 11: Viết store cho phép người dùng xóa phòng ban bằng cách người dùng nhập vào tên phòng ban và các account thuộc phòng ban đó sẽ được chuyển về phòng ban default là phòng ban chờ việc

-- Question 12: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong năm nay

-- Question 13: Viết store để in ra mỗi tháng có bao nhiêu câu hỏi được tạo trong 6 tháng gần đây nhất (Nếu tháng nào không có thì sẽ in ra là "không có câu hỏi nào trong tháng")