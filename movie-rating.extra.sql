/***************************************************************
Q1. Find the names of all reviewers who rated Gone with the Wind.
***************************************************************/
select distinct(re.name)
from Reviewer re, Rating ra, Movie m
on re.rId = ra.rId and ra.mId = m.mId
where m.title = 'Gone with the Wind';

/***************************************************************
Q2. For any rating where the reviewer is the same as the director
    of the movie, return the reviewer name, movie title,
    and number of stars.
***************************************************************/
select re.name, m.title, ra.stars
from Rating ra, Reviewer re, Movie m
on ra.rId = re.rId and ra.mId = m.mId
where m.director = re.name;


/***************************************************************
Q3. Return all reviewer names and movie names together in a
    single list, alphabetized. (Sorting by the first name of
    the reviewer and first word in the title is fine;
    no need for special processing on last names or removing "The".)
***************************************************************/
select name
from Reviewer
union
select title
from Movie
order by name, title;

/***************************************************************
Q4. Find the titles of all movies not reviewed by Chris Jackson.
***************************************************************/
select title
from Movie
where title not in (
	select m.title
	from Reviewer re, Rating ra, Movie m
	on re.rId = ra.rId and m.mId = ra.mId
	where re.name = 'Chris Jackson'
);

/***************************************************************
Q5. For all pairs of reviewers such that both reviewers gave
    a rating to the same movie, return the names of both reviewers.
    Eliminate duplicates, don't pair reviewers with themselves,
    and include each pair only once. For each pair,
    return the names in the pair in alphabetical order.
***************************************************************/
select distinct re1.name, re2.name
from Rating ra1, Rating ra2, Reviewer re1, Reviewer re2
where ra1.mId = ra2.mId
and ra1.rId = re1.rId
and ra2.rId = re2.rId
and re1.name < re2.name
order by re1.name;

/***************************************************************
Q6. For each rating that is the lowest (fewest stars)
    currently in the database, return the reviewer name,
    movie title, and number of stars.
***************************************************************/
select re.name, m.title, ra.stars
from Reviewer re, Movie m, Rating ra
on ra.rId = re.rId and m.mId = ra.mId
where ra.stars = (
	select min(stars)
	from Rating
);

/***************************************************************
Q7. List movie titles and average ratings, from highest-rated
    to lowest-rated. If two or more movies have the same average
    rating, list them in alphabetical order.
***************************************************************/
select m.title, avg(ra.stars)
from Rating ra, Movie m
on ra.mId = m.mId
group by m.title
order by avg(ra.stars) desc, m.title;

/***************************************************************
Q8. Find the names of all reviewers who have contributed three
    or more ratings. (As an extra challenge, try writing the
    query without HAVING or without COUNT.)
***************************************************************/
select name
from Reviewer
where (
	select count(*)
	from Rating r
	where r.rId = Reviewer.rId
) >= 3;

/***************************************************************
Q9. Some directors directed more than one movie. For all such
    directors, return the titles of all movies directed by them,
    along with the director name. Sort by director name,
    then movie title. (As an extra challenge, try writing
    the query both with and without COUNT.)
***************************************************************/
select title, director
from Movie
where (
	select count(*)
	from Movie m
	where m.director = Movie.director
) > 1
order by director, title;

/***************************************************************
Q10. Find the movie(s) with the highest average rating.
    Return the movie title(s) and average rating.
    (Hint: This query is more difficult to write in SQLite
    than other systems; you might think of it as finding
    the highest average rating and then choosing the movie(s)
    with that average rating.)
***************************************************************/
select m.title, avg(r.stars)
from Movie m, Rating r
on m.mId = r.mId
group by m.title
having avg(r.stars) = (
	select avg(stars)
	from Rating
	group by mId
	order by avg(stars) desc limit 1
);

/***************************************************************
Q11. Find the movie(s) with the lowest average rating.
    Return the movie title(s) and average rating.
    (Hint: This query may be more difficult to write in SQLite
    than other systems; you might think of it as finding
    the lowest average rating and then choosing the movie(s)
    with that average rating.)
***************************************************************/
select m.title, avg(r.stars)
from Movie m, Rating r
on m.mId = r.mId
group by m.title
having avg(r.stars) = (
	select avg(stars)
	from Rating
	group by mId
	order by avg(stars) asc limit 1
);

/***************************************************************
Q12. For each director, return the director's name together
    with the title(s) of the movie(s) they directed that received
    the highest rating among all of their movies, and the value
    of that rating. Ignore movies whose director is NULL.
***************************************************************/
select m.director, m.title, max(r.stars)
from Movie m, Rating r
on m.mId = r.mId
where m.director is not null
group by m.director;
