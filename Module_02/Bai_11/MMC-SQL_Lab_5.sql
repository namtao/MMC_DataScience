--Question 1: Tạo view có chứa danh sách nhân viên thuộc phòng ban sale
CREATE VIEW
    V_lstNvSale AS
SELECT
    a.*
FROM
    `account` a
    JOIN groupaccount ga ON a.`AccountID` = ga.`AccountID`
WHERE
    `GroupID` = 1;

--Question 2: Tạo view có chứa thông tin các account tham gia vào nhiều group nhất
CREATE VIEW
    v_accountMultiGroup AS
SELECT
    *
FROM
    `account`
WHERE
    `AccountID` = (
        SELECT
            `AccountID`
        FROM
            groupaccount
        GROUP BY
            `AccountID`
        HAVING
            COUNT(`AccountID`) = (
                SELECT
                    MAX(a.sl)
                FROM
                    (
                        SELECT
                            `AccountID`,
                            COUNT(`AccountID`) as 'sl'
                        from
                            groupaccount
                        GROUP BY
                            `AccountID`
                    ) a
            )
    );

--Question 3: Tạo view có chứa câu hỏi có những content quá dài (content quá 300 từ được coi là quá dài) và xóa nó đi
CREATE VIEW
    v_lenContentQuestion AS
SELECT
    *
FROM
    question
WHERE
    LENGTH (`Content`) > 30;

--Question 4: Tạo view có chứa danh sách các phòng ban có nhiều nhân viên nhất
CREATE VIEW
    v_maxNV AS
SELECT
    `DepartmentID`
FROM
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
                    COUNT(`DepartmentID`) as 'sl'
                FROM
                    `account`
                GROUP BY
                    `DepartmentID`
            ) a
    );

--Question 5: Tạo view có chứa tất các các câu hỏi do user họ Nguyễn tạo
CREATE VIEW
    v_maxQuestionByFullname AS
SELECT
    q.*
FROM
    question q
    JOIN `account` a on q.`CreatorID` = a.`AccountID`
WHERE
    `FullName` like N'Nguyễn%';