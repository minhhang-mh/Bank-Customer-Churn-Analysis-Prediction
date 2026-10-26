USE BankCustomerChurn
GO

CREATE OR ALTER VIEW vw_BankCustomerChurn_train AS
SELECT 
	id,
    CustomerId,
    Surname,
    CreditScore,
    Geography,
    Gender,
    Age,
    Tenure,
    Balance,
    NumOfProducts,
    HasCrCard,
    IsActiveMember,
    EstimatedSalary,
    Exited,

    -- 1. Age Group
    CASE 
        WHEN Age < 30 THEN '1. 18-29'
        WHEN Age BETWEEN 30 AND 39 THEN '2. 30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '3. 40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '4. 50-59'
        ELSE '5. 60+'
    END AS AgeGroup,

    -- 2. Tenure Group
    CASE 
        WHEN Tenure >= 10 THEN '10+'
        ELSE CAST(Tenure AS VARCHAR(10))
    END AS TenureGroup,

    -- 3. Financial Groups
		-- Balance Group
    CASE 
        WHEN Balance = 0 THEN '1. Zero Balance'
        WHEN Balance < 100000 THEN '2. Low (< 100K)'
        WHEN Balance BETWEEN 100000 AND 150000 THEN '3. Medium (100K-150K)'
        ELSE '4. High (> 150K)'
    END AS BalanceGroup,
		-- Credit Tier
    CASE 
        WHEN CreditScore < 580 THEN '1. 300-579: Poor'
        WHEN CreditScore BETWEEN 580 AND 669 THEN '2. 580-669: Fair'
        WHEN CreditScore BETWEEN 670 AND 739 THEN '3. 670-739: Good'
        WHEN CreditScore BETWEEN 740 AND 799 THEN '4. 740-799: Very Good'
        ELSE '5. 800-850: Excellent'
    END AS CreditTier,
		-- Salary Group
    CASE 
        WHEN EstimatedSalary < 50000 THEN '1. 0-50K - Low'
        WHEN EstimatedSalary BETWEEN 50000 AND 100000 THEN '2. 50K-100K - Middle'
        WHEN EstimatedSalary BETWEEN 100000 AND 150000 THEN '3. 100K-150K - High'
        ELSE '4. 150K+ - Very High'
    END AS SalaryGroup

FROM BankCustomerChurn_train