DROP TABLE IF EXISTS NETFLIX;

CREATE TABLE NETFLIX
(
SHOW_ID VARCHAR(7),
TYPE VARCHAR(10),
TITLE VARCHAR(150),
DIRECTOR VARCHAR(210),
CASTS VARCHAR(800),
COUNTRY VARCHAR(150),
DATE_ADDED VARCHAR(50),
RELEASE_YEAR INT, RATING VARCHAR(10),
DURATION VARCHAR(15),
LISTED_IN VARCHAR(100),
DESCRIPTION VARCHAR(250)
);

SELECT * FROM NETFLIX;

SELECT COUNT(*) AS TOTAL_ROWS
FROM NETFLIX;

--Q1
SELECT TYPE,
	COUNT(*)
FROM NETFLIX
GROUP BY TYPE;

--Q2
SELECT TYPE,
	RATING
FROM
	(SELECT TYPE,RATING,COUNT(*),
		RANK()OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS RANKING
		FROM NETFLIX
		GROUP BY TYPE,RATING) AS X
WHERE RANKING = 1;

--Q3
SELECT * from netflix where type='Movie' and release_year= '2020';

--Q4
select unnest(STRING_TO_ARRAY(country,', ')) as new_country, 
count(show_id) as contents from netflix 
where country!='null' group by new_country order by contents desc limit 5;

--Q5  
SELECT * FROM NETFLIX WHERE type = 'Movie' 
AND CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER) =
    (SELECT MAX(CAST(SPLIT_PART(duration, ' ', 1) AS INTEGER))
FROM netflix WHERE TYPE='Movie');

--Q6 
select * from netflix
WHERE TO_DATE(date_added,'Month FMDD,YYYY')>= CURRENT_DATE - INTERVAL '5 Years';

-- Q7 
select * from netflix where director ilike '%Rajiv Chilaka%';

--Q8
select * from netflix where type='TV Show' 
and cast(split_part(duration,' ',1) as INTEGER) >5;

--Q9
select unnest(STRING_TO_ARRAY(listed_in,', ')) as genre,count(show_id) as contents 
from netflix group by genre;

--Q10
SELECT 
    EXTRACT(Year From (TO_DATE(date_added,'Month FMDD,YYYY')))as Year,
	count(*) as content_added,
	ROUND(
		COUNT(show_id)::numeric/(SELECT COUNT(show_id) FROM netflix WHERE country ILIKE '%India%')::numeric * 100 
		,2)
		as percent_release
FROM netflix
WHERE country ILIKE '%India%' 
GROUP BY Year
Order by percent_release desc limit 5;

--Q11
select * from netflix where listed_in ILIKE '%Documentaries%' and type='Movie';

--Q12
select * from netflix where director is NULL;

--Q13
SELECT * FROM netflix where casts ilike '%SALMAN KHAN%'
AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 15;

--Q14
select unnest(STRING_TO_ARRAY(casts,', ')) as actor, count(show_id) as contents 
from netflix where country ILIKE '%India%' group by actor order by contents desc limit 10;

--Q15
select category,type, count(*) as contents from(
Select * ,
case	
 when description ILIKE '%kill%' or description ILIKE '%VIOLENCE%' THEN 'Bad'
 else 'Good'
End as category
	from netflix
) as category
group by category, type
order by contents desc;