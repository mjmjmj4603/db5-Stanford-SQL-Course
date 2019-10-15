-- SQL Movie-Rating Query Exercises
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_query_core/

-- Movie ( mID, title, year, director )
-- Reviewer ( rID, name )
-- Rating ( rID, mID, stars, ratingDate )

-- Question 1:
-- Find the titles of all movies directed by Steven Spielberg.
select title 
from movie 
where director = 'Steven Spielberg'

-- Question 2:
-- Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order.
select distinct year 
from movie, rating 
where movie.mid = rating.mid and (stars = 4 or stars = 5) 
order by year;

-- Question 3:
-- Find the titles of all movies that have no ratings.
select title
from movie left join rating using (mID)
where stars is null

-- Question 4:
-- Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings
-- with a NULL value for the date.
select name 
from rating join reviewer using (rID)
where ratingdate is null

-- Question 5:
-- Write a query to return the ratings data in a more readable format: reviewer name, movie title, stars, 
-- and ratingDate. Also, sort the data, first by reviewer name, then by movie title, and lastly by number of stars.
select name, title, stars, ratingdate 
from movie join reviewer join rating using (mid, rid)
order by name, title, stars

-- Question 6:
-- For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time, 
-- return the reviewer's name and the title of the movie.
select distinct name, title
from movie join reviewer join rating using (mid, rid)
where rid in (select rid
              from rating r1 join rating r2 using (rid, mid)
              where r1.ratingdate < r2.ratingdate and r1.stars < r2.stars)
              
-- Question 7:
-- For each movie that has at least one rating, find the highest number of stars that movie received. 
-- Return the movie title and number of stars. Sort by movie title.
select title, max(stars)
from movie join rating using (mid)
group by title
order by title

-- Question 8:
-- For each movie, return the title and the 'rating spread', the difference between highest and lowest ratings given to that movie. 
-- Sort by rating spread from highest to lowest, then by movie title. 
select title, max(stars) - min(stars) as spread
from rating join movie using (mid)
group by mid
order by spread desc, title

-- Question 9:
-- Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980. 
-- (Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after. 
-- Don't just calculate the overall average rating before and after 1980.) 
select avg(early.avgStar) - avg(late.avgStar)
from (select avg(stars) as avgStar
      from Movie join Rating using(mID)
      group by mID
      having year < 1980) as early,
      (select avg(stars) as avgStar
      from Movie join Rating using(mID)
      group by mID
      having year > 1980) as late