/***************************************************************
Q1. Find the names of all students who are friends with
    someone named Gabriel.
***************************************************************/
select h1.name
from Highschooler h1
inner join Friend on h1.ID = Friend.ID1
inner join Highschooler h2 on h2.ID = Friend.ID2
where h2.name = "Gabriel";

/***************************************************************
Q2. For every student who likes someone 2 or more grades
    younger than themselves, return that student's name and grade,
    and the name and grade of the student they like.
***************************************************************/
select h1.name, h1.grade, h2.name, h2.grade
from Highschooler h1
inner join Likes on h1.ID = Likes.ID1
inner join Highschooler h2 on h2.ID = Likes.ID2
where h1.grade - 2 >= h2.grade;

/***************************************************************
Q3. For every pair of students who both like each other,
    return the name and grade of both students.
    Include each pair only once, with the two names in alphabetical order.
***************************************************************/
select h1.name, h1.grade, h2.name, h2.grade
from Highschooler h1, Highschooler h2, Likes l1, Likes l2
where (h1.ID = L1.ID1 and h2.ID = L1.ID2)
and (h2.ID = l2.ID1 and h1.id = L2.ID2)
and h1.name < h2.name;

/***************************************************************
Q4. Find all students who do not appear in the Likes table
    (as a student who likes or is liked) and return their names
    and grades. Sort by grade, then by name within each grade.
***************************************************************/
select name, grade
from Highschooler
where ID not in (
  select distinct ID1
  from Likes
  union
  select distinct ID2
  from Likes
)
order by grade, name;

/***************************************************************
Q5. For every situation where student A likes student B,
    but we have no information about whom B likes
    (that is, B does not appear as an ID1 in the Likes table),
    return A and B's names and grades.
***************************************************************/
select h1.name, h1.grade, h2.name, h2.grade
from Highschooler h1, Highschooler h2, Likes l
where (h1.ID = l.ID1 and h2.ID = l.ID2)
and h2.ID not in (
	select ID1
	from Likes
);

/***************************************************************
Q6. Find names and grades of students who only have friends
    in the same grade. Return the result sorted by grade,
    then by name within each grade.
***************************************************************/
select name, grade
from Highschooler h1
where ID not in (
	select ID1
	from Friend f, Highschooler h2
	where h1.ID = f.ID1
	and h2.ID = f.ID2
	and h1.grade <> h2.grade
)
order by grade, name;

/***************************************************************
Q7. For each student A who likes a student B where the two are
    not friends, find if they have a friend C in common
    (who can introduce them!). For all such trios,
    return the name and grade of A, B, and C.
***************************************************************/
select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from Highschooler h1, Highschooler h2, Highschooler h3, Likes l, Friend f1, Friend f2
where (h1.ID = l.ID1 and h2.ID = l.ID2)
and h1.ID not in (
	select ID1
	from Friend
	where h2.ID = ID2
)
and (h1.ID = f1.ID1 AND h3.ID = f1.ID2)
and (h2.ID = f2.ID1 AND h3.ID = f2.ID2);

/***************************************************************
Q8. Find the difference between the number of students in
    the school and the number of different first names.
***************************************************************/
select count(*) - count(distinct name)
from Highschooler;

/***************************************************************
Q1. Find the name and grade of all students who are liked by
    more than one other student.
***************************************************************/
select name, grade
from Highschooler h
inner join Likes on h.ID = Likes.ID2
group by ID2
having count(*) > 1;
