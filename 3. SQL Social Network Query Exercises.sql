-- SQL Social Network Query Exercises
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_social_query_core/

-- Question 1:
-- Find the names of all students who are friends with someone named Gabriel.
select name
from Highschooler
where ID in (select ID1 from Friend
             where ID2 in (select ID from Highschooler where name = 'Gabriel'))

-- Question 2:
-- For every student who likes someone 2 or more grades younger than themselves, return that student's
-- name and grade, and the name and grade of the student they like.
select h1.name, h1.grade, h2.name, h2.grade
from Highschooler as h1, Highschooler as h2, Likes as l
where h1.ID = l.ID1 
  and h2.ID = l.ID2 
  and h1.grade = h2.grade + 2

-- Question 3:
-- For every pair of students who both like each other, return the name and grade of both students. Include
-- each pair only once, with the two names in alphabetical order.
select h1.name, h1.grade, h2.name, h2.grade
from Highschooler as h1, Highschooler as h2, Likes as l1, Likes as l2
where h1.ID = l1.ID1 
  and h2.ID = l1.ID2 
  and h2.ID = l2.ID1
  and h1.ID = l2.ID2 
  and h1.name < h2.name

-- Question 4:
-- Find all students who do not appear in the Likes table (as a student who likes or is liked) and return their
-- names and grades. Sort by grade, then by name within each grade.
select name, grade
from Highschooler
where ID not in (select ID1 from Likes) and ID not in (select ID2 from Likes)
order by grade, name

-- Question 5:
-- For every situation where student A likes student B, but we have no information about whom B likes (that is,
-- B does not appear as an ID1 in the Likes table), return A and B's names and grades.
select h1.name, h1.grade, h2.name, h2.grade
from Highschooler as h1, Highschooler as h2, Likes as l1
where h1.ID = l1.ID1 
  and h2.ID = l1.ID2 
  and h2.ID not in (select ID1 from Likes)

-- Question 6:
-- Find names and grades of students who only have friends in the same grade. Return the result sorted by grade,
-- then by name within each grade.
select name, grade
from Highschooler
where ID not in (select h1.ID from Highschooler as h1, Highschooler as h2,Friend as f1
                 where h1.ID = f1.ID1 
                   and h2.ID = f1.ID2 
                   and h1.grade <> h2.grade)
order by grade, name

-- Question 7:
-- For each student A who likes a student B where the two are not friends, find if they have a friend C in common
-- (who can introduce them!). For all such trios, return the name and grade of A, B, and C.
select distinct h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from Highschooler as h1, Highschooler as h2, Highschooler as h3, Likes as l1, Friend as f1
where h1.ID = l1.ID1 and h2.ID = l1.ID2 
  and h2.ID not in (select ID2 from Friend where h1.ID = ID1)
  and h3.ID in (select ID2 from Friend where h1.ID = ID1)
  and h3.ID in (select ID2 from Friend where h2.ID = ID1)

-- Question 8:
-- Find the difference between the number of students in the school and the number of different first names.
select count(ID) - count(distinct name)
from Highschooler

-- Question 9:
-- Find the name and grade of all students who are liked by more than one other student.
select name, grade
from Highschooler
where ID in (select ID2 
             from Likes 
			 group by ID2 
             having count(distinct ID1) > 1)