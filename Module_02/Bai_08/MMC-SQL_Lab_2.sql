-- Active: 1714535278653@@127.0.0.1@3306@testing_system_db
CREATE DATABASE Testing_System_Db DEFAULT CHARACTER
SET
    = 'utf8';

CREATE Table
    IF NOT EXISTS Department (
        DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
        DepartmentName VARCHAR(50)
    );

INSERT INTO
    Department (DepartmentName)
VALUES
    ('Accounting'),
    ('Research'),
    ('Sales'),
    ('IT'),
    ('Marketing'),
    ('Human Resources'),
    ('Finance'),
    ('Operations'),
    ('Legal'),
    ('Customer Service');

CREATE Table
    IF NOT EXISTS `Position` (
        PositionID INT PRIMARY KEY AUTO_INCREMENT,
        PositionName VARCHAR(50)
    );

INSERT INTO
    Position(PositionName)
VALUES
    ('Software Engineer'),
    ('Data Scientist'),
    ('Product Manager'),
    ('UX Designer'),
    ('Sales Representative'),
    ('Marketing Manager'),
    ('Financial Analyst'),
    ('Operations Manager'),
    ('Legal Counsel'),
    ('Customer Support Specialist');

CREATE Table
    IF NOT EXISTS Account (
        AccountID INT PRIMARY KEY AUTO_INCREMENT,
        Email VARCHAR(50),
        Username VARCHAR(50),
        FullName VARCHAR(50),
        DepartmentID INT,
        PositionID INT,
        CreateDate DATE,
        FOREIGN KEY (DepartmentID) REFERENCES Department (DepartmentID),
        FOREIGN KEY (PositionID) REFERENCES `Position` (PositionID)
    );

INSERT INTO
    Account (
        Email,
        Username,
        FullName,
        DepartmentID,
        PositionID,
        CreateDate
    )
VALUES
    (
        '[account1@example.com](mailto:account1@example.com)',
        'user1',
        'User One',
        1,
        1,
        NOW ()
    ),
    (
        '[account2@example.com](mailto:account2@example.com)',
        'user2',
        'User Two',
        2,
        2,
        NOW ()
    ),
    (
        '[account3@example.com](mailto:account3@example.com)',
        'user3',
        'User Three',
        3,
        3,
        NOW ()
    ),
    (
        '[account4@example.com](mailto:account4@example.com)',
        'user4',
        'User Four',
        4,
        4,
        NOW ()
    ),
    (
        '[account5@example.com](mailto:account5@example.com)',
        'user5',
        'User Five',
        5,
        5,
        NOW ()
    ),
    (
        '[account6@example.com](mailto:account6@example.com)',
        'user6',
        'User Six',
        6,
        6,
        NOW ()
    ),
    (
        '[account7@example.com](mailto:account7@example.com)',
        'user7',
        'User Seven',
        7,
        7,
        NOW ()
    ),
    (
        '[account8@example.com](mailto:account8@example.com)',
        'user8',
        'User Eight',
        8,
        8,
        NOW ()
    ),
    (
        '[account9@example.com](mailto:account9@example.com)',
        'user9',
        'User Nine',
        9,
        9,
        NOW ()
    ),
    (
        '[account10@example.com](mailto:account10@example.com)',
        'user10',
        'User Ten',
        10,
        10,
        NOW ()
    );

CREATE Table
    IF NOT EXISTS `Group` (
        GroupID INT PRIMARY KEY AUTO_INCREMENT,
        GroupName VARCHAR(50),
        CreatorID INT,
        CreateDate DATE,
        FOREIGN KEY (CreatorID) REFERENCES Account (AccountID)
    );

INSERT INTO
    `Group` (GroupName, CreatorID, CreateDate)
VALUES
    ('Group 1', 1, NOW ()),
    ('Group 2', 2, NOW ()),
    ('Group 3', 3, NOW ()),
    ('Group 4', 4, NOW ()),
    ('Group 5', 5, NOW ()),
    ('Group 6', 6, NOW ()),
    ('Group 7', 7, NOW ()),
    ('Group 8', 8, NOW ()),
    ('Group 9', 9, NOW ()),
    ('Group 10', 10, NOW ());

CREATE Table
    IF NOT EXISTS GroupAccount (
        GroupID INT PRIMARY KEY AUTO_INCREMENT,
        AccountID INT,
        JoinDate DATE,
        FOREIGN KEY (GroupID) REFERENCES `Group` (GroupID),
        FOREIGN KEY (AccountID) REFERENCES Account (AccountID)
    );

INSERT INTO
    GroupAccount (AccountID, GroupID, JoinDate)
VALUES
    (1, 1, NOW ()),
    (2, 1, NOW ()),
    (3, 1, NOW ()),
    (4, 2, NOW ()),
    (5, 2, NOW ()),
    (6, 2, NOW ()),
    (7, 3, NOW ()),
    (8, 3, NOW ()),
    (9, 3, NOW ()),
    (10, 4, NOW ());

CREATE Table
    IF NOT EXISTS TypeQuestion (
        TypeID INT PRIMARY KEY AUTO_INCREMENT,
        TypeName VARCHAR(50)
    );

INSERT INTO
    TypeQuestion (TypeName)
VALUES
    ('Multiple Choice'),
    ('True or False'),
    ('Short Answer'),
    ('Essay'),
    ('Matching'),
    ('Fill in the Blank'),
    ('Ranking'),
    ('Likert Scale'),
    ('Sequencing'),
    ('Numeric');

CREATE Table
    IF NOT EXISTS CategoryQuestion (
        CategoryID INT PRIMARY KEY AUTO_INCREMENT,
        CategoryName VARCHAR(50)
    );

INSERT INTO
    CategoryQuestion (CategoryName)
VALUES
    ('Programming'),
    ('Data Analysis'),
    ('Web Development'),
    ('Database Management'),
    ('Cloud Computing'),
    ('Network Security'),
    ('Project Management'),
    ('Software Testing'),
    ('Version Control'),
    ('Agile Methodologies');

CREATE Table
    IF NOT EXISTS Question (
        QuestionID INT PRIMARY KEY AUTO_INCREMENT,
        Content VARCHAR(50),
        CategoryID INT,
        TypeID INT,
        CreatorID INT,
        CreateDate DATE,
        FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion (CategoryID),
        FOREIGN KEY (TypeID) REFERENCES TypeQuestion (TypeID)
    );

INSERT INTO
    Question (
        Content,
        CategoryID,
        TypeID,
        CreatorID,
        CreateDate
    )
VALUES
    ('Q1', 1, 2, 1, NOW ()),
    ('Q2', 2, 2, 2, NOW ()),
    ('Q3', 3, 1, 3, NOW ()),
    ('Q4', 4, 3, 4, NOW ()),
    ('Q5?', 5, 3, 5, NOW ()),
    ('Q6', 6, 3, 6, NOW ()),
    ('Q7', 7, 3, 7, NOW ()),
    ('Q8', 8, 3, 8, NOW ()),
    ('Q9', 9, 3, 9, NOW ()),
    ('Q10', 10, 3, 10, NOW ());

CREATE Table
    IF NOT EXISTS Answer (
        AnswerID INT PRIMARY KEY AUTO_INCREMENT,
        Content VARCHAR(50),
        QuestionID INT,
        isCorrect DATE,
        FOREIGN KEY (QuestionID) REFERENCES Question (QuestionID)
    );

INSERT INTO
    Answer (Content, QuestionID, isCorrect)
VALUES
    ('A1', 1, TRUE),
    ('A2', 2, TRUE),
    ('A3', 3, TRUE),
    ('A4', 4, TRUE),
    ('A5', 5, TRUE),
    ('A6', 6, TRUE),
    ('A7', 7, TRUE),
    ('A8', 8, TRUE),
    ('A9', 9, TRUE),
    ('A10', 10, TRUE);

CREATE Table
    IF NOT EXISTS Exam (
        ExamID INT PRIMARY KEY AUTO_INCREMENT,
        `Code` VARCHAR(50),
        Title VARCHAR(50),
        CategoryID INT,
        Duration INT,
        CreatorID INT,
        CreateDate DATE,
        FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion (CategoryID)
    );

INSERT INTO
    Exam (
        Code,
        Title,
        CategoryID,
        Duration,
        CreatorID,
        CreateDate
    )
VALUES
    ('EXAM001', 'T1', 1, 60, 1, NOW ()),
    ('EXAM002', 'T2', 2, 60, 2, NOW ()),
    ('EXAM003', 'T3', 3, 60, 3, NOW ()),
    ('EXAM004', 'T4', 4, 60, 4, NOW ()),
    ('EXAM005', 'T5', 5, 60, 5, NOW ()),
    ('EXAM006', 'T6', 6, 60, 6, NOW ()),
    ('EXAM007', 'T7', 7, 60, 7, NOW ()),
    ('EXAM008', 'T8', 8, 60, 8, NOW ()),
    ('EXAM009', 'T9', 9, 60, 9, NOW ()),
    ('EXAM010', 'T10', 10, 60, 10, NOW ());

CREATE Table
    IF NOT EXISTS ExamQuestion (
        ExamID INT,
        QuestionID INT,
        FOREIGN KEY (ExamID) REFERENCES Exam (ExamID),
        FOREIGN KEY (QuestionID) REFERENCES Question (QuestionID)
    );

INSERT INTO
    ExamQuestion (ExamID, QuestionID)
VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (2, 4),
    (2, 5),
    (2, 6),
    (3, 7),
    (3, 8),
    (3, 9),
    (4, 10);