-- 1. 总贷款笔数
SELECT COUNT(*) AS 总行数 
FROM financial_loan;

-- 2. 贷款状态分布
SELECT 
    loan_status AS 贷款状态, 
    COUNT(*) AS 笔数,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM financial_loan), 2) AS 占比
FROM financial_loan
GROUP BY loan_status;

-- 3. 总放款金额与总回款
SELECT 
    SUM(loan_amount) AS 总放款金额,
    SUM(total_payment) AS 总回款金额,
    ROUND(SUM(total_payment) / SUM(loan_amount) * 100, 2) AS 回款率
FROM financial_loan;

-- 4. 平均利率和平均DTI
SELECT 
    ROUND(AVG(int_rate)*100, 2) AS 平均利率,
    ROUND(AVG(dti)*100, 2) AS 平均DTI
FROM financial_loan;


-- 5. 按贷款状态看金额与风险指标
SELECT 
    loan_status AS 贷款状态,
    COUNT(*) AS 贷款笔数,
    SUM(loan_amount) AS 总放款金额,
    ROUND(AVG(int_rate)*100, 2) AS 平均利率,
    ROUND(AVG(dti)*100, 2) AS 平均DTI
FROM financial_loan
GROUP BY loan_status;

-- 6. 好贷款 vs 坏贷款对比
SELECT 
    CASE 
        WHEN loan_status IN ('Fully Paid', 'Current') THEN '好贷款'
        ELSE '坏贷款'
    END AS 贷款质量,
    COUNT(*) AS 笔数,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM financial_loan), 2) AS 占比,
    SUM(loan_amount) AS 总放款金额
FROM financial_loan
GROUP BY 
    CASE 
        WHEN loan_status IN ('Fully Paid', 'Current') THEN '好贷款'
        ELSE '坏贷款'
    END;

-- 7. 按信用等级（grade）看坏账率
SELECT 
    grade AS 信用等级,
    COUNT(*) AS 总贷款笔数,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS 坏账笔数,
    ROUND(SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS 坏账率
FROM financial_loan
GROUP BY grade
ORDER BY grade;

-- 8. 按贷款目的（purpose）看坏账率
SELECT 
    purpose AS 贷款目的,
    COUNT(*) AS 总贷款笔数,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS 坏账笔数,
    ROUND(SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS 坏账率,
    SUM(loan_amount) AS 总放款金额
FROM financial_loan
GROUP BY purpose
ORDER BY 坏账率 DESC;

-- 9. 按贷款期限（term）看坏账率
SELECT 
    term AS 贷款期限,
    COUNT(*) AS 总贷款笔数,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS 坏账笔数,
    ROUND(SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS 坏账率,
    ROUND(AVG(int_rate)*100, 2) AS 平均利率
FROM financial_loan
GROUP BY term
ORDER BY term;

-- 10. 按房屋所有权（home_ownership）看坏账率
SELECT 
    home_ownership AS 房屋所有权,
    COUNT(*) AS 总贷款笔数,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS 坏账笔数,
    ROUND(SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS 坏账率,
    SUM(loan_amount) AS 总放款金额
FROM financial_loan
GROUP BY home_ownership
ORDER BY 坏账率 DESC;

-- 11. 按州（address_state）看坏账率（取坏账率最高的前15个州）
SELECT 
    address_state AS 州,
    COUNT(*) AS 总贷款笔数,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) AS 坏账笔数,
    ROUND(SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS 坏账率,
    SUM(loan_amount) AS 总放款金额
FROM financial_loan
GROUP BY address_state
HAVING COUNT(*) >= 100
ORDER BY 坏账率 DESC
LIMIT 15;