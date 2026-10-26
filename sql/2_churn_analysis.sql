USE BankCustomerChurn
GO

-- CHECKING DATA

SELECT * FROM BankCustomerChurn_train;

--1. Overall Churn Status
SELECT COUNT(*) AS TotalCustomers,
	SUM(CASE WHEN Exited = 0 THEN 1 ELSE 0 END) AS RetainedCustomers,
	ROUND(SUM(CASE WHEN Exited = 0 THEN 1 ELSE 0 END) * 100.0 /COUNT(*), 2)  AS RetentionRate,
	SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 /COUNT(*), 2)  AS ChurnRate
FROM BankCustomerChurn_train;

--2. Churn Rate by Demographics

	-- Churn Rate by Geography
SELECT Geography,
	COUNT(*) AS TotalCustomers,
	SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 /COUNT(*), 2)  AS ChurnRate,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / SUM(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)) OVER(), 2) AS ShareOfChurn -- ChurnCustomer/TotalChurnCustomer Rate
FROM BankCustomerChurn_train
GROUP BY Geography;

	-- Churn Rate by Gender
SELECT Gender,
	COUNT(*) AS TotalCustomers,
	SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 /COUNT(*), 2)  AS ChurnRate,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / SUM(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)) OVER(), 2) AS ShareOfChurn
FROM BankCustomerChurn_train
GROUP BY Gender;

	-- Churn Rate by Geography & Gender
SELECT Geography, 
	Gender,
	COUNT(*) AS TotalCustomers,
	SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 /COUNT(*), 2)  AS ChurnRate,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / SUM(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)) OVER(), 2) AS ShareOfChurn
FROM BankCustomerChurn_train
GROUP BY Geography,
		Gender
ORDER BY ChurnRate DESC;

	-- Churn Rate by Age Group
WITH AgeGroups AS (
    SELECT Exited,
        CASE 
			WHEN Age < 30 THEN '1. 18-29'
			WHEN Age BETWEEN 30 AND 39 THEN '2. 30-39'
			WHEN Age BETWEEN 40 AND 49 THEN '3. 40-49'
			WHEN Age BETWEEN 50 AND 59 THEN '4. 50-59'
			ELSE '5. 60+'
		END AS AgeGroup
    FROM BankCustomerChurn_train
)
SELECT
    AgeGroup,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRate,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / SUM(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)) OVER(), 2) AS ShareOfChurn 
FROM AgeGroups
GROUP BY AgeGroup;

--3. Churn Rate by Behavioral

	-- Churn Rate by Number of Products
SELECT NumOfProducts,
	COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRate,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / SUM(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)) OVER(), 2) AS ShareOfChurn
FROM BankCustomerChurn_train
GROUP BY NumOfProducts
ORDER BY NumOfProducts ASC;

	-- Churn Rate by Tenure
SELECT Tenure,
	COUNT(*) AS TotalCustomers,
	SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRate,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / SUM(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)) OVER(), 2) AS ShareOfChurn
FROM BankCustomerChurn_train
WHERE Tenure <=10
GROUP BY Tenure
ORDER BY Tenure ASC;

	-- Churn Rate by Is Active Member
SELECT IsActiveMember,
	COUNT(*) AS TotalCustomers,
	SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRate,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / SUM(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)) OVER(), 2) AS ShareOfChurn
FROM BankCustomerChurn_train
GROUP BY IsActiveMember;

	-- Churn Rate by Has Credit Card
SELECT HasCrCard,
	COUNT(*) AS TotalCustomers,
	SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRate,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / SUM(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)) OVER(), 2) AS ShareOfChurn
FROM BankCustomerChurn_train
GROUP BY HasCrCard;

--4. Churn Rate by Financial

	-- Churn Rate by Credit Score
SELECT MIN(CreditScore) AS MinCreditScore,
	MAX(CreditScore) AS MaxCreditScore,
	AVG(CreditScore) AS AvgCreditScore
FROM BankCustomerChurn_train;
	--> Standard FICO Score  (300-850)
WITH CreditScoreTiers AS (
    SELECT Exited,
        CASE
            WHEN CreditScore BETWEEN 300 AND 579 THEN '1. 300-579: Poor'
			WHEN CreditScore BETWEEN 580 AND 669 THEN '2. 580-669: Fair'
			WHEN CreditScore BETWEEN 670 AND 739 THEN '3. 670-739: Good'
			WHEN CreditScore BETWEEN 740 AND 799 THEN '4. 740-799: Very Good'
            ELSE '5. 800-850: Excellent'
        END AS CreditTier
    FROM BankCustomerChurn_train
)
SELECT
    CreditTier,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRate,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / SUM(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)) OVER(), 2) AS ShareOfChurn -- ChurnCustomer/TotalChurnCustomer Rate
FROM CreditScoreTiers
GROUP BY CreditTier
ORDER BY CreditTier ASC;

	-- Churn Rate by Estimated Salary Group
SELECT Exited,
	AVG(EstimatedSalary) AS AverageSalary
FROM BankCustomerChurn_train
GROUP BY Exited;

WITH SalaryGroups AS (
    SELECT Exited,
        CASE 
            WHEN EstimatedSalary < 50000 THEN '1. 0-50K - Low Salary'
            WHEN EstimatedSalary BETWEEN 50000 AND 100000 THEN '2. 50K-100K - Middle Salary'
            WHEN EstimatedSalary BETWEEN 100000 AND 150000 THEN '3. 100K-150K - High Salary'
            ELSE '4. 150K+ - Very High Salary'
        END AS SalaryGroup
    FROM BankCustomerChurn_train
)
SELECT 
    SalaryGroup,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRate,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / SUM(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)) OVER(), 2) AS ShareOfChurn
FROM SalaryGroups
GROUP BY SalaryGroup
ORDER BY SalaryGroup ASC;

	-- Churn Rate by Balance

	-- Churn Rate by NonZeroBalance vs ZeroBalance
WITH BalanceStatus AS (
    SELECT Exited,
        CASE
            WHEN Balance = 0 THEN '1. 0: Zero Balance'
            ELSE '2. > 0: Non-Zero Balance'
        END AS BalanceType
    FROM BankCustomerChurn_train
)
SELECT
    BalanceType,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRate,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / SUM(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)) OVER(), 2) AS ShareOfChurn
FROM BalanceStatus
GROUP BY BalanceType
ORDER BY BalanceType;

	-- Churn Rate by NonZeroBalanceGroup
SELECT MIN(Balance) AS MinBalance, 
	MAX(Balance) AS MaxBalance,
	AVG(Balance) AS AvgBalance
FROM BankCustomerChurn_train
WHERE Balance > 0;

WITH NonZeroBalanceGroups AS (
    SELECT Exited,
        CASE 
            WHEN Balance < 100000 THEN '1. < 100K - Low'
            WHEN Balance BETWEEN 100000 AND 150000 THEN '2. 100K-150K - Medium'
            ELSE '3. > 150K - High'
        END AS NonZeroBalanceGroup
    FROM BankCustomerChurn_train
	WHERE Balance > 0
)
SELECT 
    NonZeroBalanceGroup,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRate,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / SUM(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)) OVER(), 2) AS ShareOfNonZeroChurn
FROM NonZeroBalanceGroups
GROUP BY NonZeroBalanceGroup
ORDER BY NonZeroBalanceGroup ASC;

-- 5. German Churn Customer with Age Group
SELECT AgeGroup,
	COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRate,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / SUM(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)) OVER(), 2) AS ShareOfGermanyChurn
FROM vw_BankCustomerChurn_train
WHERE Geography = 'Germany' 
GROUP BY AgeGroup
ORDER BY AgeGroup;

-- 6. Churn Rate by Geography, Gender, IsActiveMember
SELECT 
    Geography,
    Gender,
    IsActiveMember,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRate,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / SUM(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)) OVER(), 2) AS ShareOfChurn
FROM BankCustomerChurn_train
GROUP BY Geography, Gender, IsActiveMember;

-- 7. Churn Rate by BalanceGroup & IsActiveMember
SELECT 
    BalanceGroup,
    IsActiveMember,
    COUNT(*) AS TotalCustomers,
    SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) AS ChurnedCustomers,
    ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ChurnRate,
	ROUND(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) * 100.0 / SUM(SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END)) OVER(), 2) AS ShareOfChurn
FROM vw_BankCustomerChurn_train
GROUP BY BalanceGroup, IsActiveMember
ORDER BY BalanceGroup ASC, IsActiveMember ASC



