-- Active: 1714535278653@@127.0.0.1@3306@testing_system_db
CREATE DATABASE Testing_System_Db DEFAULT CHARACTER
SET
    = 'utf8';

CREATE Table
    IF NOT EXISTS Department (
        DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
        DepartmentName VARCHAR(50)
    );

CREATE Table
    IF NOT EXISTS `Position` (
        PositionID INT PRIMARY KEY AUTO_INCREMENT,
        PositionName VARCHAR(50)
    );

CREATE Table
    IF NOT EXISTS Account (
        AccountID INT PRIMARY KEY AUTO_INCREMENT,
        Email VARCHAR(50),
        Username VARCHAR(50),
        FullName VARCHAR(50),
        DepartmentID INT,
        PositionID INT,
        CreateDate DATE
    );

CREATE Table
    IF NOT EXISTS `Group` (
        GroupID INT PRIMARY KEY AUTO_INCREMENT,
        GroupName VARCHAR(50),
        CreatorID INT,
        CreateDate DATE
    );

CREATE Table
    IF NOT EXISTS GroupAccount (
        GroupID INT PRIMARY KEY AUTO_INCREMENT,
        AccountID INT,
        JoinDate DATE
    );

CREATE Table
    IF NOT EXISTS TypeQuestion (
        TypeID INT PRIMARY KEY AUTO_INCREMENT,
        TypeName VARCHAR(50)
    );

CREATE Table
    IF NOT EXISTS CategoryQuestion (
        CategoryID INT PRIMARY KEY AUTO_INCREMENT,
        CategoryName VARCHAR(50)
    );

CREATE Table
    IF NOT EXISTS Question (
        QuestionID INT PRIMARY KEY AUTO_INCREMENT,
        Content VARCHAR(50),
        CategoryID INT,
        TypeID INT,
        CreatorID INT,
        CreateDate DATE
    );

CREATE Table
    IF NOT EXISTS Answer (
        AnswerID INT PRIMARY KEY AUTO_INCREMENT,
        Content VARCHAR(50),
        QuestionID INT,
        isCorrect DATE
    );

CREATE Table
    IF NOT EXISTS Exam (
        ExamID INT PRIMARY KEY AUTO_INCREMENT,
        `Code` VARCHAR(50),
        Title VARCHAR(50),
        CategoryID INT,
        Duration INT,
        CreatorID INT,
        CreateDate DATE
    );

CREATE Table
    IF NOT EXISTS ExamQuestion (ExamID INT, QuestionID INT);