Approach:- tried to solve one problem at each time extracting month and year from the date and then grouping by month and country to get the count of transactions, count of approved transactions, total amount of transactions and total amount of approved transactions for each month and country, group by was thing to notice earlier though using of partition by month, country but that was too much
SELECT 
    DATE_FORMAT(trans_date, "%Y-%m") AS month,
    country,
    COUNT(*) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY DATE_FORMAT(trans_date, "%Y-%m"), country;