/***************************************************************
Q1. Find the titles of all movies directed by Steven Spielberg.
***************************************************************/
select title from Movie where director = 'Steven Spielberg';

/***************************************************************
Q2. Find all years that have a movie that received
    a rating of 4 or 5, and sort them in increasing order.
***************************************************************/
select distinct m.year
from Rating r, Movie m
where r.stars >= 4
and m.mId = r.mId
order by m.year;

/***************************************************************
Q3. Find the titles of all movies that have no ratings.
***************************************************************/
select distinct m.title
from Movie m, Rating r
where m.mID not in(
select m.mID
from Movie m, Rating r
where m.mID = r.mID);

/***************************************************************
Q4. Some reviewers didn't provide a date with their rating.
    Find the names of all reviewers who have ratings
    with a NULL value for the date.
***************************************************************/
select rev.name
from Rating rat, Reviewer rev
on rat.rId = rev.rId
where rat.ratingDate is null;

/***************************************************************
Q5. Write a query to return the ratings data in a more readable
    format: reviewer name, movie title, stars, and ratingDate.
    Also, sort the data, first by reviewer name, then by
    movie title, and lastly by number of stars.
***************************************************************/
select rev.name, m.title, rat.stars, rat.ratingDate
from Rating rat, Reviewer rev, Movie m
on rev.rId = rat.rId and rat.mId = m.mId
order by rev.name, m.title, rat.stars;

/***************************************************************
Q6. For all cases where the same reviewer rated the same movie
    twice and gave it a higher rating the second time,
    return the reviewer's name and the title of the movie.
***************************************************************/
select rev.name, m.title
from Rating rat1, Rating rat2, Reviewer rev, Movie m
where rat1.rID = rat2.rID
and rat1.RatingDate < rat2.RatingDate
and rat1.mID = rat2.mID
and rat1.stars < rat2.stars
and rat2.mID = m.mID
and rat2.rID = rev.rID;

/***************************************************************
Q7. For each movie that has at least one rating, find the highest
    number of stars that movie received.
    Return the movie title and number of stars. Sort by movie title.
***************************************************************/
select m.title, max(r.stars)
from  movie m, rating r
where m.mID = r.mID
group by m.mID
order by m.title;

/***************************************************************
Q8. For each movie, return the title and the 'rating spread',
    that is, the difference between highest and lowest ratings
    given to that movie. Sort by rating spread from highest to
    lowest, then by movie title.
***************************************************************/
select m.title, max(r.stars) - min(r.stars)
from Movie m, Rating r
on m.mId = r.mId
group by m.mId
order by max(r.stars) - min(r.stars) desc, title;

/***************************************************************
Q9. Find the difference between the average rating of movies
    released before 1980 and the average rating of movies released
    after 1980.
    (Make sure to calculate the average rating for each movie,
    then the average of those averages for movies before 1980 and
    movies after. Don't just calculate the overall average rating
    before and after 1980.)
***************************************************************/
select(abs(avg(before.avg) - avg(after.avg)))
from (
	(
		/* average rating for each movie before 1980 */
		select avg(r.stars) as avg
		from Rating r, Movie m
		on m.mId = r.mId
		where m.year < 1980
		group by m.mId
	) as before,
	(
		/* average rating for each movie before 1980 */
		select avg(r.stars) as avg
		from Rating r, Movie m
		on m.mId = r.mId
		where m.year > 1980
		group by m.mId
	) as after
);
