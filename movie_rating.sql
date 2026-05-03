--Approach:- tried to solve one problem at each time extracting month and year from the date and then grouping by month and country to get the count of transactions, count of approved transactions, total amount of transactions and total amount of approved transactions for each month and country,
-- group by was thing to notice earlier though using of partition by month, country but that was too much for lexographical order of name asc has worked for tie breaker in case of same number of movies rated by users and same average rating for movies in a month, also used limit 1 to get only one result as asked in question, also used union all to combine results from both ctes as they are of same data type and structure

WITH cte1 AS (
    SELECT u.user_id, u.name,
           COUNT(mr.movie_id) AS no_of_rated_movies
    FROM Users u
    LEFT JOIN MovieRating mr 
        ON u.user_id = mr.user_id
    GROUP BY u.user_id, u.name
    ORDER BY no_of_rated_movies DESC, u.name ASC
    LIMIT 1
),
cte2 AS (
    SELECT 
        m.title,
        DATE_FORMAT(mr.created_at, '%Y-%m') AS month,
        AVG(mr.rating) AS avg_rating,
        RANK() OVER (
            PARTITION BY DATE_FORMAT(mr.created_at, '%Y-%m')
            ORDER BY AVG(mr.rating) DESC, m.title ASC
        ) AS rnk
    FROM Movies m
    JOIN MovieRating mr 
        ON m.movie_id = mr.movie_id where DATE_FORMAT(mr.created_at, '%Y-%m')='2020-02'
    GROUP BY m.title, month limit 1
)
select name as results from cte1 union all 
select title from cte2