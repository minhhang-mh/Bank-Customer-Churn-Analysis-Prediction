CREATE DATABASE BankCustomerChurn
USE BankCustomerChurn
GO

-- 
SELECT COUNT(*) AS Total_Rows,
	SUM(CASE WHEN CustomerId IS NULL OR CustomerId = '' THEN 1 ELSE 0 END) AS Missing_CustomerId,
	SUM(CASE WHEN Surname IS NULL OR Surname = '' THEN 1 ELSE 0 END) AS Missing_Surname,
	SUM(CASE WHEN Geography IS NULL OR Geography = '' THEN 1 ELSE 0 END) AS Missing_Geography,
	SUM(CASE WHEN Gender IS NULL OR Gender = '' THEN 1 ELSE 0 END) AS Missing_Gender,

	SUM(CASE WHEN CreditScore IS NULL OR CreditScore = '' THEN 1 ELSE 0 END) AS Missing_CreditScore,
	SUM(CASE WHEN Age IS NULL OR Age = '' THEN 1 ELSE 0 END) AS Missing_Age,
	SUM(CASE WHEN Tenure IS NULL OR Tenure = '' THEN 1 ELSE 0 END) AS Missing_Tenure,
	SUM(CASE WHEN Balance IS NULL OR Balance = '' THEN 1 ELSE 0 END) AS Missing_Balance,
	SUM(CASE WHEN NumOfProducts IS NULL OR NumOfProducts = '' THEN 1 ELSE 0 END) AS Missing_NumOfProducts,
	SUM(CASE WHEN HasCrCard IS NULL OR HasCrCard = '' THEN 1 ELSE 0 END) AS Missing_HasCrCard,
	SUM(CASE WHEN IsActiveMember IS NULL OR IsActiveMember = '' THEN 1 ELSE 0 END) AS Missing_IsActiveMember,
	SUM(CASE WHEN EstimatedSalary IS NULL OR EstimatedSalary = '' THEN 1 ELSE 0 END) AS Missing_EstimatedSalary,
	SUM(CASE WHEN Exited IS NULL OR Exited = '' THEN 1 ELSE 0 END) AS Missing_Exited
FROM stg_train 

-- 
CREATE TABLE BankCustomerChurn_train (
			id INT,
			CustomerId INT,
			Surname NVARCHAR(50),
			CreditScore INT,
			Geography VARCHAR(10),
			Gender VARCHAR(10),
			Age INT,
			Tenure INT,
			Balance DECIMAL(18,2),
			NumOfProducts INT,
			HasCrCard BIT,
			IsActiveMember BIT,
			EstimatedSalary DECIMAL(10,2),
			Exited BIT
			)

-- 
INSERT INTO BankCustomerChurn_train
SELECT
	id,
	CAST(CAST(CustomerId AS FLOAT) AS INT) AS CustomerId,
	Surname,
	CAST(CAST(CreditScore AS FLOAT) AS INT) AS CreditScore,
	Geography,
	Gender,
	CAST(CAST(Age AS FLOAT) AS INT) AS Age,
	CAST(CAST(Tenure AS FLOAT) AS INT) AS Tenure,
	CAST(CAST(Balance AS FLOAT) AS DECIMAL(18,2)) AS Balance,
	CAST(CAST(NumOfProducts AS FLOAT) AS INT) AS NumOfProducts,
	CAST(CAST(HasCrCard AS FLOAT) AS BIT) AS HasCrCard,
	CAST(CAST(IsActiveMember AS FLOAT) AS BIT) AS IsActiveMember,
	CAST(CAST(EstimatedSalary AS FLOAT) AS DECIMAL(10,2)) AS EstimatedSalary,
	CAST(CAST(Exited AS FLOAT) AS BIT) AS Exited
FROM stg_train

SELECT TOP 10 * FROM BankCustomerChurn_train



