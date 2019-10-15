-- Extra SQL Social Network Query Exercises
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_social_query_extra/

-- Question 1:
-- For every situation where student A likes student B, but student B likes a different student C, return the names
-- and grades of A, B, and C.
select distinct h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from Highschooler as h1, Highschooler as h2, Highschooler as h3, Likes as l1, Likes as l2
where h1.ID = l1.ID1 and h2.ID = l1.ID2 
  and h2.ID = l2.ID1 and h3.ID = l2.ID2
  and h1.ID <> l2.ID2

-- Question 2:
-- Find those students for whom all of their friends are in different grades from themselves. Return the students' names
-- and grades.
select name, grade
from Highschooler
where ID not in (select h1.ID 
                 from Highschooler as h1,Highschooler as h2,Friend as f1
                 where h1.ID = f1.ID1 
                   and h2.ID = f1.ID2 
				   and h1.grade = h2.grade)

-- Question 3:
-- What is the average number of friends per student? (Your result should be just one number.)
select avg(friends)
from (select count(ID2) as friends from Friend group by ID1)

-- Question 4:
-- Find the number of students who are either friends with Cassandra or are friends of friends
-- of Cassandra. Do not count Cassandra, even though technically she is a friend of a friend.
select count(distinct f1.ID1)
from Friend as f1, Friend as f2, (select ID from Highschooler where name = 'Cassandra') as C
where f1.ID2 = C.ID 
   or (f1.ID1 <> C.ID and f1.ID2 = f2.ID1 and f2.ID2 = C.ID)
   
-- if A(f1.id1) is friend of B, then f1.id2 = B
-- if A is a friend of friend of B, then f1.id1 != B, f1.id2 = f2.id1, f2.id2 = B

-- Question 5:
-- Find the name and grade of the student(s) with the greatest number of friends.
select name, grade
from Highschooler join Friend
on ID = ID1
group by name, grade
having count(ID2) = (select max(f.numF)
					from(select count(ID2) as numF from Friend group by ID1) as f)