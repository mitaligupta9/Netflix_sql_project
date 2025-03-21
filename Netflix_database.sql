 -- Count the number of Movies vs TV Shows

select show_type,
	count(show_id) as "total_of content"
	from netflix
	group by 1


-- Find the most common rating for movies and TV shows

select * from
	(select show_type,
	rating,
	count(show_id) as "total_content",
	rank() over(partition by show_type order by count(show_id) desc) as "ranking"
	from netflix
	group by 1,2)
where ranking = 1
	
	
-- List all movies released in a specific year (e.g., 2020)

	select * from netflix
	where show_type = 'Movie'
	and release_year = 2020
	
	
-- Find the top 5 countries with the most content on Netflix

	
	select unnest(string_to_array(country, ',')),
	count(show_id) as "total_content"
	from netflix
	group by 1
	order by 2 desc
	limit 5
	
	
-- Identify the longest movie

select show_type, 
	title,
	duration
	from netflix
	where show_type = 'Movie' and duration = (select max(duration) from netflix)


-- Find content added in the last 5 years

	select show_type,
	title,
	date_added:: date from netflix
	where date_added:: date > current_date - interval '5 years'

	
-- Find all the movies/TV shows by director 'Rajiv Chilaka'!

select show_type,
	director
	from netflix
	where director like '%Rajiv Chilaka%'
	
	
-- List all TV shows with more than 5 seasons

select * from 	
	(select show_type,
	title,
	duration,
	split_part(duration,' ',1):: int as "season"
	from netflix
	where show_type = 'TV Show')
	where season > 5
	
	
-- Count the number of content items in each genre

select 
	show_type,
	unnest(string_to_array(listed_in,',')) as "type_of_content", 
	count(show_id)
	from netflix	
	group by 1,2
	order by 3 desc
	
	
-- Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!


	
	select
	Extract('Year' from date_added:: date),
	count(*),
	round(count(*)::numeric/(select count(*) from netflix where country = 'India'),2) * 100 as "Avg_content"
	from netflix
	where country = 'India'
	group by 1


	
	
-- List all movies that are documentaries

	select * from
(select show_id,
	show_type,
	title,
	unnest(string_to_array(listed_in,',')) as "genre"
	from netflix
	where show_type = 'Movie')
where genre = 'Documentaries'


-- Find all content without a director

select show_type,
	title,
	director
	from netflix
	where director is null
	
	
-- Find how many movies actor 'Salman Khan' appeared in last 10 years!

	
	select 
	title,
	show_cast,
	release_year
	from netflix
	where show_cast like '%Salman Khan%' and 
	release_year :: numeric >= Extract('Year' from current_date - interval '10 years' )
	

	
-- Find the top 10 actors who have appeared in the highest number of movies produced in India.

select unnest(string_to_array(show_cast,',')),
	count(show_id)
	from netflix
	where country like 'India%'
group by 1
	order by 2 desc
	limit 10


-- Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.


select content_based,
	count(*) from
(select show_type,
	title,
	descriptions, 
	case 
		when descriptions Ilike '%kill%' then 'bad'
		when descriptions Ilike '%violence%' then 'bad'
		else 'good'
	end as content_based
	from netflix)
group by 1




