SELECT title
FROM movies
JOIN (
    SELECT movie_id
    FROM stars
    WHERE person_id
    IN (
        SELECT id
        FROM people
        WHERE name
        IN (
            "Jennifer Lawrence",
            "Bradley Cooper"
        )
    )
    GROUP BY movie_id
    HAVING COUNT (DISTINCT person_id) = 2
) both_id
ON movies.id = both_id.movie_id;
