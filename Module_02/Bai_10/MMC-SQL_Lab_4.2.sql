-- Active: 1714535278653@@127.0.0.1@3306@testing_system_db
--Q1: Viết lệnh để lấy ra danh sách nhân viên và thông tin phòng ban của họ
SELECT
    *
from
    `account` a
    JOIN department d ON a.`DepartmentID` = d.`DepartmentID`
    join position p on a.`PositionID` = p.`PositionID`;

--Q2: Viết lệnh để lấy ra thông tin các account được tạo sau ngày 20/12/2010
SELECT
    *
FROM
    `account`
WHERE
    `CreateDate` < STR_TO_DATE ('20/12/2010', '%d/%m/%Y');

--Q3: Viết lệnh để lấy ra tất cả các developer
SELECT
    *
from
    `account` a
    JOIN department d ON a.`DepartmentID` = d.`DepartmentID`
    join position p on a.`PositionID` = p.`PositionID`
WHERE
    `DepartmentName` = 'IT';

--Q4: Viết lệnh để lấy ra danh sách các phòng ban có >3 nhân viên
SELECT
    COUNT(*)
from
    `account`
GROUP BY
    `DepartmentID`
HAVING
    COUNT(*) > 3;

--Q5: Viết lệnh để lấy ra danh sách câu hỏi được sử dụng trong đề thi nhiều nhất
SELECT
    `QuestionID`,
    COUNT(*)
from
    examquestion
GROUP BY
    `QuestionID`
HAVING
    COUNT(*) = (
        SELECT
            MAX(a.sl)
        FROM
            (
                SELECT
                    `QuestionID`,
                    COUNT(`QuestionID`) AS sl
                FROM
                    examquestion
                GROUP BY
                    `QuestionID`
            ) a
    );

--Q6: Thống kê mỗi category Question được sử dụng trong bao nhiêu Question
SELECT
    cq.`CategoryID`,
    COUNT(*)
FROM
    categoryquestion cq
    JOIN question q ON cq.`CategoryID` = q.`CategoryID`
GROUP BY
    `CategoryID`;

--Q7: Thống kê mỗi Question được sử dụng trong bao nhiêu Exam
SELECT
    Q.QuestionId,
    Q.Content,
    COUNT(EQ.QuestionId) AS 'SL'
FROM
    ExamQuestion EQ
    RIGHT JOIN Question Q ON EQ.QuestionID = Q.QuestionID
GROUP BY
    Q.QuestionID;

--Q8: Lấy ra Question có nhiều câu trả lời nhất
SELECT
    `QuestionID`
from
    answer
GROUP BY
    `QuestionID`
having
    COUNT(*) = (
        SELECT
            MAX(tb.sl)
        from
            (
                SELECT
                    q.`QuestionID`,
                    COUNT(*) AS sl
                FROM
                    answer a
                    JOIN question q on a.`QuestionID` = q.`QuestionID`
                GROUP BY
                    q.`QuestionID`
            ) tb
    );

--Question 9: Thống kê số lượng account trong mỗi group
SELECT
    g.`GroupID`,
    COUNT(ga.`GroupID`) as 'SL account'
FROM
    groupaccount ga
    LEFT JOIN `account` a on a.`AccountID` = ga.`AccountID`
    RIGHT JOIN `group` g on g.`GroupID` = ga.`GroupID`
GROUP BY
    g.`GroupID`;

--Q10: Tìm chức vụ có ít người nhất
SELECT
    `DepartmentID`
from
    `account`
GROUP BY
    `DepartmentID`
HAVING
    COUNT(`DepartmentID`) = (
        SELECT
            MAX(a.sl)
        FROM
            (
                SELECT
                    `DepartmentID`,
                    COUNT(*) as 'sl'
                from
                    `account`
                GROUP BY
                    `DepartmentID`
            ) a
    );

-- Q11: Thống kê mỗi phòng ban có bao nhiêu dev, test, scrum master, PM
-- Q12: Lấy thông tin chi tiết của câu hỏi bao gồm: thông tin cơ bản của question, loại câu hỏi, ai là người tạo ra câu hỏi, câu trả lời là gì, …
SELECT
    *
FROM
    question q
    JOIN categoryquestion aq ON q.`CategoryID` = aq.`CategoryID`
    JOIN typequestion tq ON q.`TypeID` = tq.`TypeID`
    JOIN `account` a ON q.`CreatorID` = a.`AccountID`;

-- Q13: Lấy ra số lượng câu hỏi của mỗi loại tự luận hay trắc nghiệm
SELECT
    q.`TypeID`,
    COUNT(q.`TypeID`)
FROM
    question q
    JOIN typequestion tq ON q.`TypeID` = tq.`TypeID`
GROUP BY
    q.`TypeID`;

-- Q14 + Q15: Lấy ra group không có account nào
SELECT
    *
from
    `group`
WHERE
    `GroupID` NOT IN (
        SELECT
            `GroupID`
        FROM
            groupaccount
    );

--Q16: Lấy ra question không có answer nào
SELECT
    *
from
    question
WHERE
    `QuestionID` NOT IN (
        SELECT
            `QuestionID`
        FROM
            answer
    );

-- Q17: 
-- Lấy các account thuộc nhóm thứ 1
-- Lấy các account thuộc nhóm thứ 2
-- Ghép 2 kết quả từ câu a) và câu b) sao cho không có record nào trùng nhau

SELECT * from `account` a JOIN groupaccount ga on a.`AccountID` = ga.`AccountID` WHERE `GroupID` = 1
UNION
SELECT * from `account` a JOIN groupaccount ga on a.`AccountID` = ga.`AccountID` WHERE `GroupID` = 1

--Q18: 
--a) Lấy các group có lớn hơn 5 thành viên
--b) Lấy các group có nhỏ hơn 7 thành viên
--c) Ghép 2 kết quả từ câu a) và câu b)

SELECT `GroupID` FROM groupaccount GROUP BY `GroupID` HAVING COUNT(`GroupID`) > 5
UNION
SELECT `GroupID` FROM groupaccount GROUP BY `GroupID` HAVING COUNT(`GroupID`) < 7
