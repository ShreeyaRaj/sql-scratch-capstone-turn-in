---Select all columns from first 10 rows of survey table
SELECT * 
FROM survey
LIMIT 10;

---Create a funnel of survey to see when users "give up"
SELECT question, 
COUNT(DISTINCT user_id) AS 'User Count' 
FROM survey
GROUP BY question;

---Examine first five rows of the quiz, home_try_on and purchase tables
SELECT * 
FROM quiz
LIMIT 5;

SELECT * 
FROM home_try_on
LIMIT 5;

SELECT * 
FROM purchase
LIMIT 5;

---Create a Home Try-On Funnel
SELECT DISTINCT Q.user_id,
  H.user_id IS NOT NULL AS 'is_home_try_on',
  H.number_of_pairs,
  P.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS Q
LEFT JOIN home_try_on AS H
   ON Q.user_id = H.user_id
LEFT JOIN purchase AS P
   ON P.user_id = Q.user_id
LIMIT 10;


--- Use funnel to compare conversion from quiz --> home_try_on and home_try_on --> purchase
WITH funnel AS (
SELECT DISTINCT Q.user_id,
   H.user_id IS NOT NULL AS 'is_home_try_on',
   H.number_of_pairs,
   P.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS Q
LEFT JOIN home_try_on AS H
   ON Q.user_id = H.user_id
LEFT JOIN purchase AS P
   ON P.user_id = Q.user_id)
SELECT COUNT(*) AS 'num_quiz', 
SUM(is_home_try_on) AS 'num_home_try_on', 
SUM(is_purchase) AS 'num_purchase', 
1.0*SUM(is_home_try_on) / COUNT(user_id) AS 'quiz_to_home_try_on', 
1.0*SUM(is_purchase) / SUM(is_home_try_on) AS 'home_try_on_to_purchase' 
FROM funnel;

---Calculare difference in purchase rates between customers who had 3 pairs of frames and 5 pairs of frame
WITH funnel AS (
SELECT DISTINCT Q.user_id,
   H.user_id IS NOT NULL AS 'is_home_try_on',
   H.number_of_pairs,
   P.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS Q
LEFT JOIN home_try_on AS H
   ON Q.user_id = H.user_id
LEFT JOIN purchase AS P
   ON P.user_id = Q.user_id)
SELECT number_of_pairs, ROUND(1.0 * SUM(is_purchase) / COUNT(*),2) AS 'purchase_rate'
FROM funnel
GROUP BY number_of_pairs;

---Find the number of purchases made at each price point
SELECT price, COUNT(*) AS 'Count'
FROM purchase
GROUP BY price
ORDER BY price ASC;

---Find the number of purchases made for each type of model
SELECT model_name, COUNT(*) AS 'Count'
FROM purchase
GROUP BY model_name;
