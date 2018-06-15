SELECT DISTINCT utm_source AS 'Sources', 
       utm_campaign as 'Campaigns'
FROM page_visits;
________________________________________________________________________________________________________________________

SELECT DISTINCT page_name AS 'CoolTShirts - website pages'
FROM page_visits;
________________________________________________________________________________________________________________________

WITH 
first_touch AS (
  SELECT user_id, MIN(timestamp) AS first_touch_at
  FROM page_visits
  GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_campaign,
         pv.utm_source
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source AS 'UTM Source', 
       ft_attr.utm_campaign AS 'UTM Campaign', 
       COUNT(*) AS 'Total First-touches'
FROM ft_attr
GROUP BY 1,2
ORDER BY 3 DESC;
________________________________________________________________________________________________________________________

WITH 
last_touch AS (
  SELECT user_id, MAX(timestamp) as  last_touch_at
  FROM page_visits
  GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'UTM Source',  
       lt_attr.utm_campaign AS 'UTM Campaign', 
       COUNT(*) AS 'Total Last-touches'
FROM lt_attr
GROUP BY 1,2
ORDER BY 3 DESC;
________________________________________________________________________________________________________________________

SELECT COUNT(DISTINCT user_id) AS ‘Visitors that purchased'
FROM page_visits
WHERE page_name = '4 - purchase';
________________________________________________________________________________________________________________________

WITH 
last_touch AS (
  SELECT user_id, MAX(timestamp) as last_touch_at
  FROM page_visits
  WHERE page_name = '4 - purchase'
  GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'UTM Source', 
       lt_attr.utm_campaign AS 'UTM Campaign', 
       COUNT(*) AS Nr. Of Purchases'
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
________________________________________________________________________________________________________________________

SELECT COUNT(DISTINCT user_id) AS 'Total Users'
FROM page_visits;
________________________________________________________________________________________________________________________

SELECT page_name AS 'Website Page', 
       COUNT(DISTINCT user_id) AS 'Nr. of Users', 
       ROUND(100.0 * (COUNT(DISTINCT user_id) / 1979.0), 2) AS 'User journey'
FROM page_visits
GROUP BY 1;
