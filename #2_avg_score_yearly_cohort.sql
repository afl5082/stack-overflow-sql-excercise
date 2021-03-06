
with yearly_cohorts as (
SELECT extract(year FROM u.creation_date) as signup_year,
       ROUND(SUM(score) / count(c.id),4) as average

FROM (SELECT 
        user_id,
        score,
        id,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY creation_date ASC) as rn 
        FROM `bigquery-public-data.stackoverflow.comments` 
        ORDER BY 1,3 ASC
       
) c
JOIN `bigquery-public-data.stackoverflow.users` u
ON c.user_id = u.id
WHERE rn between 1 and 10
GROUP BY 1
ORDER BY 1 ASC)

SELECT  signup_year,
        average,
        ROUND((( average / LAG(average)
                OVER (ORDER BY signup_year ASC)) - 1 ) 
                        * 100,2) as pct_change_previous_year
    FROM yearly_cohorts
    ORDER BY 1 ASC; 
    
    
   
