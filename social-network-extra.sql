/***************************************************************
Q1. For every situation where student A likes student B,
    but student B likes a different student C,
    return the names and grades of A, B, and C.
***************************************************************/
select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from Highschooler h1, Highschooler h2, Highschooler h3, Likes l1, Likes l2
where h1.ID = l1.ID1
and h2.ID = l1.ID2
and l2.ID1 = h2.ID
and l2.ID2 = h3.ID
and l2.ID2 is not h1.ID;

/***************************************************************
Q2. Find those students for whom all of their friends are in
    different grades from themselves. Return the students' names and grades.
***************************************************************/
select name, grade
from Highschooler h1
where h1.grade not in (
	select h2.grade
	from Friend f, Highschooler h2
	where h1.ID = f.ID1
	and h2.ID = f.ID2
);

/***************************************************************
Q3. What is the average number of friends per student?
    (Your result should be just one number.)
***************************************************************/
select avg(friends)
from (
	select count(*) as friends
	from Friend
	group by ID1
);

/***************************************************************
Q4. Find the number of students who are either friends
    with Cassandra or are friends of friends of Cassandra.
    Do not count Cassandra, even though technically she is a friend of a friend.
***************************************************************/
select count(*)
from Friend
where ID1 in (
	select ID2
	from Friend
	where ID1 is (
		select ID
		from Highschooler
		where name = 'Cassandra'
	)
);

/***************************************************************
Q5. Find the name and grade of the student(s) with the greatest number of friends.
***************************************************************/
select name, grade
from Highschooler h
inner join Friend f on h.ID = f.ID1
group by ID1
having count(*) = (
	select max(friends)
	from (
		select count(*) as friends
		from Friend
		group by ID1
	)
);
