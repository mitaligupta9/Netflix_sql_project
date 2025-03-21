Netflix Movies and TV Shows Data Analysis using SQL

https://github.com/mitaligupta9/netflix_sql_project/blob/main/logo.png


Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

Objectives
  - Analyze the distribution of content types (movies vs TV shows).
  - Identify the most common ratings for movies and TV shows.
  - List and analyze content based on release years, countries, and durations.
  - Explore and categorize content based on specific criteria and keywords.

Dataset
The data for this project is sourced from the Kaggle dataset:

Dataset Link: Movies Dataset

 1. Count the number of Movies vs TV Shows

select show_type,
	count(show_id) as "total_of content"
	from netflix
	group by 1

Objective: Determine the distribution of content types on Netflix.

2. Find the most common rating for movies and TV shows

select * from
	(select show_type,
	rating,
	count(show_id) as "total_content",
	rank() over(partition by show_type order by count(show_id) desc) as "ranking"
	from netflix
	group by 1,2)
where ranking = 1
	
Objective: Identify the most frequently occurring rating for each type of content.
 
3. List all movies released in a specific year (e.g., 2020)

	select * from netflix
	where show_type = 'Movie'
	and release_year = 2020

 Objective: Retrieve all movies released in a specific year.
	
4. Find the top 5 countries with the most content on Netflix

	
	select unnest(string_to_array(country, ',')),
	count(show_id) as "total_content"
	from netflix
	group by 1
	order by 2 desc
	limit 5

 Objective: Identify the top 5 countries with the highest number of content items.
	
5. Identify the longest movie

select show_type, 
	title,
	duration
	from netflix
	where show_type = 'Movie' and duration = (select max(duration) from netflix)

Objective: Find the movie with the longest duration.

 6.Find content added in the last 5 years

	select show_type,
	title,
	date_added:: date from netflix
	where date_added:: date > current_date - interval '5 years'

Objective: Retrieve content added to Netflix in the last 5 years.
 
7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select show_type,
	director
	from netflix
	where director like '%Rajiv Chilaka%'
	
Objective: List all content directed by 'Rajiv Chilaka'.
 
8. List all TV shows with more than 5 seasons

select * from 	
	(select show_type,
	title,
	duration,
	split_part(duration,' ',1):: int as "season"
	from netflix
	where show_type = 'TV Show')
	where season > 5
	
Objective: Identify TV shows with more than 5 seasons.
 
  9. Count the number of content items in each genre

select 
	show_type,
	unnest(string_to_array(listed_in,',')) as "type_of_content", 
	count(show_id)
	from netflix	
	group by 1,2
	order by 3 desc
	
Objective: Count the number of content items in each genre.
 
10. Find each year and the average numbers of content release in India on netflix. 
-- return top 5 year with highest avg content release!


	
	select
	Extract('Year' from date_added:: date),
	count(*),
	round(count(*)::numeric/(select count(*) from netflix where country = 'India'),2) * 100 as "Avg_content"
	from netflix
	where country = 'India'
	group by 1


Objective: Calculate and rank years by the average number of content releases by India.	
	
11. List all movies that are documentaries

	select * from
(select show_id,
	show_type,
	title,
	unnest(string_to_array(listed_in,',')) as "genre"
	from netflix
	where show_type = 'Movie')
where genre = 'Documentaries'

Objective: Retrieve all movies classified as documentaries.

12. Find all content without a director

select show_type,
	title,
	director
	from netflix
	where director is null

 Objective: List content that does not have a director.
	
13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

	
	select 
	title,
	show_cast,
	release_year
	from netflix
	where show_cast like '%Salman Khan%' and 
	release_year :: numeric >= Extract('Year' from current_date - interval '10 years' )
	
Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.
	
14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select unnest(string_to_array(show_cast,',')),
	count(show_id)
	from netflix
	where country like 'India%'
group by 1
	order by 2 desc
	limit 10

Objective: Identify the top 10 actors with the most appearances in Indian-produced movies.

15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
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

Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

Findings and Conclusion
Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.
Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.
Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.


