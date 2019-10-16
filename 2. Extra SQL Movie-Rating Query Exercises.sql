-- Extra SQL Movie-Rating Query Exercises
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_movie_query_extra/

-- Question 1:
-- Find the names of all reviewers who rated Gone with the Wind.
select distinct name
from Reviewer join Rating join movie using (rid, mid)
where title = 'Gone with the Wind'

-- Question 2:              
-- For any rating where the reviewer is the same as the director of the movie, 
-- return the reviewer name, movie title, and number of stars.
select name, title, stars
from movie join reviewer join rating using (mid,rid)
where name = director

-- Question 3:
-- Return all reviewer names and movie names together in a single list, alphabetized. 
-- (Sorting by the first name of the reviewer and first word in the title is fine; 
-- no need for special processing on last names or removing "The".)
select name from Reviewer
union
select title from Movie

-- Question 4:
-- Find the titles of all movies not reviewed by Chris Jackson. 
select title
from Movie
where mID not in (select mID from Reviewer join Rating using(rID)
                  where name = 'Chris Jackson')

-- Question 5:                               
-- For all pairs of reviewers such that both reviewers gave a rating to the same movie, return the names of both reviewers. 
-- Eliminate duplicates, don't pair reviewers with themselves, and include each pair only once. 
-- For each pair, return the names in the pair in alphabetical order.
select distinct r1.name,r2.name
from (Rating join Reviewer using(rID)) as r1, (Rating join Reviewer using(rID)) as r2
where r1.name < r2.name and r1.mID = r2.mID

-- Question 6:
-- For each rating that is the lowest (fewest stars) currently in the database, 
-- return the reviewer name, movie title, and number of stars.
select name, title, stars
from movie join reviewer join rating using (mid, rid)
where stars in (select min(stars) from rating)

-- Question 7:
-- List movie titles and average ratings, from highest-rated to lowest-rated. 
-- If two or more movies have the same average rating, list them in alphabetical order. 
select title, avg(stars) as avg
from Rating join Movie using(mID)
group by mID
order by avg desc, title

-- Question 8:
-- Find the names of all reviewers who have contributed three or more ratings. 
-- (As an extra challenge, try writing the query without HAVING or without COUNT.) 
select name
from Reviewer join rating using (rid)
group by rid
having count(rID) >= 3;

-- Question 9:
-- Some directors directed more than one movie. For all such directors, 
-- return the titles of all movies directed by them, along with the director name. 
-- Sort by director name, then movie title.
select title,director
from Movie
where director in (select director from Movie 
                   group by director
                   having count(director)>1)
order by director,title

-- As an extra challenge, try writing the query both with and without COUNT.
select distinct m1.title, m1.director
from Movie m1, Movie m2
where m1.director = m2.director and m1.title <> m2.title
order by m1.director, m1.title

-- Question 10:
-- Find the movie(s) with the highest average rating. Return the movie title(s) and average rating. 
-- (Hint: This query is more difficult to write in SQLite than other systems; 
-- you might think of it as finding the highest average rating and then choosing the movie(s) with that average rating.) 
select M.title, M.avg
from (select title, avg(stars) as avg 
      from Movie join Rating using(mID)
      group by mID) as M
where M.avg = (select max(avg)
               from (select avg(stars) as avg from Rating
               group by mID))

-- Question 11:
-- Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating. 
-- (Hint: This query may be more difficult to write in SQLite than other systems; 
-- you might think of it as finding the lowest average rating and then choosing the movie(s) with that average rating.) 
select M.title, M.avg
from (select title, avg(stars) as avg 
      from Movie join Rating using(mID)
      group by mID) as M
where M.avg = (select min(avg)
               from (select avg(stars) as avg from Rating
               group by mID))

-- Question 12:
-- For each director, return the director's name together with the title(s) of the movie(s) 
-- they directed that received the highest rating among all of their movies, and the value of that rating. 
-- Ignore movies whose director is NULL.
select distinct director, title, stars
from (movie join rating using (mid)) as m
where stars in (select max(stars) 
                from rating join movie using (mid) 
                where m.director = director)