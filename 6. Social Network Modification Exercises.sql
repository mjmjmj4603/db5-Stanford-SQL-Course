-- Social Network Modification Exercises
-- https://lagunita.stanford.edu/courses/DB/SQL/SelfPaced/courseware/ch-sql/seq-exercise-sql_social_mod/

-- Question 1:
-- It's time for the seniors to graduate. Remove all 12th graders from Highschooler.
delete from Highschooler
where grade = 12

-- Question 2:
-- If two students A and B are friends, and A likes B but not vice-versa, remove the Likes tuple.
delete from likes
where id1 in (select likes.id1 
              from friend join likes using (id1) 
              where friend.id2 = likes.id2) 
      and not id2 in (select likes.id1 
                      from friend join likes using (id1) 
                      where friend.id2 = likes.id2)
                      
-- Question 3:
-- For all cases where A is friends with B, and B is friends with C, add a new friendship for the pair A and C.
-- Do not add duplicate friendships, friendships that already exist, or friendships with oneself. (This one is a
-- bit challenging; congratulations if you get it right.)		
insert into friend
select f1.id1, f2.id2
from friend f1 join friend f2 on f1.id2 = f2.id1
where f1.id1 <> f2.id2
except
select * from friend
