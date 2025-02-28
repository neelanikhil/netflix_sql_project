-- Netflix project
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix(
show_id VARCHAR(6),
type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(208),
castS VARCHAR(1000),
country VARCHAR(150),
date_added  VARCHAR(50),
release_year INT, 
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(250)
);
SELECT * FROM netflix;


SELECT COUNT(*) FROM netflix as total_content;


-- 20 Business Problems

-- 1.Count the number of Movies vs TV Shows
select type,
count(*) as total_content
from netflix
group by type 

-- 2. Find the most common rating for movies and TV shows
select 
type,
rating
from
(select type,rating,
count(*),
Rank() over(partition by type order by count(*) desc) as  ranking
from netflix
group by 1,2 ) as t1
where ranking = 1


-- 3. List all movies released in a specific year (e.g., 2020)
SELECT * FROM netflix
where type = 'Movie' AND release_year = '2020'

-- 4. Find the top 5 countries with the most content on Netflix
SELECT
     UNNEST(STRING_TO_ARRAY(country, ',')) as new_country,
	 COUNT(show_id) as total_content
	 FROM netflix
	 group by 1
	 order by 2 desc
	 limit 5


-- 5. Identify the longest movie
SELECT * FROM netflix
   WHERE 
   type = 'Movie'
   AND duration = (SELECT MAX(duration) FROM netflix)


-- 6. Find content added in the last 5 years
SELECT * FROM  netflix
    where TO_DATE (date_added, 'MONTH DD, YYYY') >= CURRENT_DATE - INTERVAL '5 YEARS'

	

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT * FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'


-- 8. List all TV shows with more than 5 seasons
SELECT * FROM netflix 
         WHERE 
		 type = 'TV Show'
		 AND 
		 SPLIT_PART(duration, ' ', 1)::numeric > 5 

		 

--9. Count the number of content items in each genre
SELECT 
UNNEST(STRING_TO_ARRAY (listed_in, ',')) as Genre,
COUNT(show_id) as total_counts
FROM netflix
GROUP BY 1


--10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!
SELECT  EXTRACT(YEAR FROM TO_DATE(date_added,'MONTH DD, YYYY')) AS year,
COUNT(*) AS yearly_content,
ROUND(
COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India')::numeric * 100,2) 
as avg_content_year FROM netflix
Where country ='India'
Group By 1
)


-- 11. List all movies that are documentaries

SELECT * FROM netflix
WHERE listed_in ILIKE '%documentaries%'


--12. Find all content without a director
SELECT * FROM netflix
WHERE director IS NULL



-- 13. Find how many movies actor 'Salman Khan' appeared in last 20 years!
SELECT * FROM netflix
WHERE casts ILIKE '%salman khan%'
AND
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 20



-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
COUNT(*) AS total_count
FROM netflix
WHERE country ILIKE  '%India%'
Group by 1
order by 2 Desc 
Limit 10



--15.
--Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

WITH new_table as
(
SELECT *,
CASE
WHEN description ILIKE '%kill%' OR
      description ILIKE '%violence%' THEN 'Bad_content' ELSE 'Good_content'
	  END category
	  From netflix
	  )
	  SELECT category,
	  COUNT(*)AS total_counts
	  FROM new_table
	  GROUP BY 1

--16.Find the top 5 most recent additions to Netflix.
SELECT title, type, date_added
FROM netflix
ORDER BY date_added DESC
LIMIT 5;


-- 17. Count how many shows were added each year.
SELECT SUBSTRING(date_added, -4) AS year_added, COUNT(*) AS count
FROM netflix
WHERE date_added IS NOT NULL
GROUP BY year_added
ORDER BY year_added DESC;

--18.Get a list of TV Shows that belong to the "Drama" genre
SELECT title, country, release_year
FROM netflix
WHERE type = 'TV Show' AND listed_in LIKE '%Drama%';

--19. Find all movies directed by "Steven Spielberg".
SELECT title, release_year, country
FROM netflix
WHERE type = 'Movie' AND director = 'Steven Spielberg';

--20.Find all TV Shows with a "TV-MA" rating.
SELECT title, release_year, listed_in
FROM netflix
WHERE type = 'TV Show' AND rating = 'TV-MA';





