-- Question 1: Tạo trigger không cho phép người dùng nhập vào Group có ngày tạo trước 1 năm trước
DROP TRIGGER IF EXISTS Trg_CheckInsertGroup;

DELIMITER $$

CREATE TRIGGER Trg_CheckInsertGroup
BEFORE INSERT ON `Group`
FOR EACH ROW
BEGIN
	DECLARE v_CreateDate DATETIME;
    SET	v_CreateDate = DATE_SUB(NOW(), interval 1 year);
    
    IF(NEW.CreateDate <= v_CreateDate) THEN
		SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = 'Can not create this group';
	END IF;
END$$

DELIMITER;

-- Question 2: Tạo trigger Không cho phép người dùng thêm bất kỳ user nào vào department "Sale" nữa, khi thêm thì hiện ra thông báo "Department "Sale" cannot add more user"

DROP TRIGGER IF EXISTS Trg_NotAddUserToSale;

DELIMITER $$

CREATE TRIGGER Trg_NotAddUserToSale
BEFORE INSERT ON `Account`
FOR EACH ROW
BEGIN
	DECLARE v_depID INT;
    SELECT d.DepartmentID INTO v_depID
    FROM 	Department d
    WHERE	d.DepartmentName = 'Sale';
    
    IF (NEW.DepartmentID = v_depID) THEN
		SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = 'Can not add more User to Sale Department';
	END IF;
END$$

DELIMITER;

-- Question 3: Cấu hình 1 group có nhiều nhất là 5 user
DROP TRIGGER IF EXISTS Trg_CheckInsertGroupUser;

DELIMITER $$

CREATE TRIGGER Trg_CheckInsertGroupUser
BEFORE INSERT ON `GroupAccount`
FOR EACH ROW
BEGIN
    DECLARE v_Count INT;
    SELECT COUNT(*) INTO v_Count
    FROM `GroupAccount` ga
    WHERE ga.GroupID = NEW.GroupID;
    IF (v_Count >= 5) THEN
        SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = 'Can not add more User to Group';
    END IF;
END $$

DELIMITER;

-- Question 4: Cấu hình 1 bài thi có nhiều nhất là 10 Question
DROP TRIGGER IF EXISTS Trg_CheckInsertExamQuestion;

DELIMITER $$

CREATE TRIGGER Trg_CheckInsertExamQuestion
BEFORE INSERT ON `ExamQuestion`
FOR EACH ROW
BEGIN
    DECLARE v_Count INT;
    SELECT COUNT(*) INTO v_Count
    FROM `ExamQuestion` eq
    WHERE eq.ExamID = NEW.ExamID;
    IF (v_Count >= 10) THEN
        SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = 'Can not add more Question to Exam';
    END IF;
END $$

DELIMITER;

-- Q5: Tạo trigger không cho phép người dùng xóa tài khoản có email là admin@gmail.com (đây là tài khoản admin, không cho phép user xóa), còn lại các tài khoản khác thì sẽ cho phép xóa và sẽ xóa tất cả các thông tin liên quan tới user đó.

DROP TRIGGER IF EXISTS Trg_DeleteUser;

DELIMITER $$

CREATE TRIGGER Trg_DeleteUser
BEFORE DELETE ON `Account`
FOR EACH ROW
BEGIN
    IF (OLD.Email = 'admin@gmail.com') THEN
        SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = 'Can not delete this user';
        ELSE
        DELETE FROM `GroupAccount` WHERE `GroupAccount`.`UserID` = OLD.`UserID`;
        DELETE FROM `ExamQuestion` WHERE `ExamQuestion`.`UserID` = OLD.`UserID`;
        DELETE FROM `ExamResult` WHERE `ExamResult`.`UserID` = OLD.`UserID`;
        DELETE FROM `Question` WHERE `Question`.`UserID` = OLD.`UserID`;
    END IF;
END $$

DELIMITER;

-- Question 6: Không sử dụng cấu hình default cho field DepartmentID của table Account, hãy tạo trigger cho phép người dùng khi tạo account không điền vào departmentID thì sẽ được phân vào phòng ban "waiting Department".

DROP TRIGGER IF EXISTS Trg_InsertAccount;

DELIMITER $$

CREATE TRIGGER Trg_InsertAccount
BEFORE INSERT ON `Account`
FOR EACH ROW
BEGIN
    IF (NEW.DepartmentID IS NULL) THEN
        SET NEW.DepartmentID = 1;
    END IF;
END $$

DELIMITER;

-- Question 7: Cấu hình 1 bài thi chỉ cho phép user tạo tối đa 4 answers cho mỗi question, trong đó có tối đa 2 đáp án đúng.
DROP TRIGGER IF EXISTS Trg_InsertExamQuestion;

DELIMITER $$

CREATE TRIGGER Trg_InsertExamQuestion
BEFORE INSERT ON `ExamQuestion`
FOR EACH ROW
BEGIN
    DECLARE countAnswers INT DEFAULT 0;
    DECLARE countCorrectAnswers INT DEFAULT 0;
    SELECT COUNT(*) INTO countAnswers FROM `Answer` WHERE `Answer`.`QuestionID` = NEW.`QuestionID` AND `Answer`.`IsCorrect`= 1;
    SELECT COUNT(*) INTO countCorrectAnswers FROM `Answer` WHERE `Answer`.`QuestionID` = NEW.`QuestionID`;
    IF (countAnswers > 4 OR countCorrectAnswers > 2) THEN
        SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = 'Can not insert this exam question';
    END IF;
END $$

DELIMITER;

-- Question 8: Viết trigger sửa lại dữ liệu cho đúng: Nếu người dùng nhập vào gender của account là nam, nữ, chưa xác định thì sẽ đổi lại thành M, F, U cho giống với cấu hình ở database
DROP TRIGGER IF EXISTS Trg_UpdateAccountGender;

DELIMITER $$

CREATE TRIGGER Trg_UpdateAccountGender
BEFORE UPDATE ON `Account`
FOR EACH ROW
BEGIN
    IF (NEW.Gender = 'Nam') THEN
        SET NEW.Gender = 'M';
        ELSEIF (NEW.Gender = 'Nữ') THEN
        SET NEW.Gender = 'F';
        ELSEIF (NEW.Gender = 'Chưa xác định') THEN
        SET NEW.Gender = 'U';
        ELSE
        SET NEW.Gender = 'U';
    END IF;
END $$
DELIMITER;

-- Question 9: Viết trigger không cho phép người dùng xóa bài thi mới tạo được 2 ngày
DROP TRIGGER IF EXISTS Trg_DeleteExam;

DELIMITER $$

CREATE TRIGGER Trg_DeleteExam
BEFORE DELETE ON `Exam`
FOR EACH ROW
BEGIN
DECLARE currentDate DATE;
SET currentDate = CURDATE();
    IF (NEW.CreatedDate > currentDate - INTERVAL 2 DAY) THEN
        SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = 'Can not delete this exam';
    END IF;
END $$

DELIMITER;

-- Question 10: Viết trigger chỉ cho phép người dùng chỉ được update, delete các question khi question đó chưa nằm trong exam nào
DROP TRIGGER IF EXISTS Trg_DeleteQuestion;

DELIMITER $$

CREATE TRIGGER Trg_UpdateQuestion
BEFORE UPDATE ON `Question`
FOR EACH ROW
BEGIN
    IF (OLD.ExamId IS NULL) THEN
        SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = 'Can not update this question';
    END IF;
END $$

DELIMITER;

-- Question 12: Lấy ra thông tin exam trong đó:
-- ● Duration <= 30 thì sẽ đổi thành giá trị "Short time"
-- ● 30 < Duration <= 60 thì sẽ đổi thành giá trị "Medium time"
-- ● Duration > 60 thì sẽ đổi thành giá trị "Long time"
SELECT
    ExamId,
    CASE
        WHEN Duration <= 30 THEN 'Short time'
        WHEN Duration > 30
        AND Duration <= 60 THEN 'Medium time'
        ELSE 'Long time'
    END AS Duration
FROM Exam;

-- Question 13: Thống kê số account trong mỗi group và in ra thêm 1 column nữa có tên là
-- the_number_user_amount và mang giá trị được quy định như sau:
-- ● Nếu số lượng user trong group =< 5 thì sẽ có giá trị là few
-- ● Nếu số lượng user trong group <= 20 và > 5 thì sẽ có giá trị là normal
-- ● Nếu số lượng user trong group > 20 thì sẽ có giá trị là higher
SELECT
    GroupID,
    COUNT(AccountID) AS the_number_user_amount,
    CASE
        WHEN COUNT(AccountID) <= 5 THEN 'few'
        WHEN COUNT(AccountID) > 5
        AND COUNT(AccountID) <= 20 THEN 'normal'
        ELSE 'higher'
    END AS the_number_user_amount
FROM Account
GROUP BY
    GroupID;

-- Question 14: Thống kê số mỗi phòng ban có bao nhiêu user, nếu phòng ban nào không có user thì sẽ thay đổi giá trị 0 thành "Không có User"
SELECT
    DepartmentID,
    CASE
        WHEN COUNT(AccountID) = 0 THEN 'Không có User'
        ELSE COUNT(AccountID)
    END AS the_number_user_amount
FROM Account
GROUP BY
    DepartmentID;