
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
DELIMITER ;

CALL `sp_getCountAccountInGroup`(1)