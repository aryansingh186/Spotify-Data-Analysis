-- spotify Databases -- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- EDA 

Delete from spotify
where duration_min = 0;

select * from spotify
where duration_min = 0;

-- Data Analysis -- 

-- 1. Retrieve the names of all tracks that have more than 1 billion streams.--
Select * from spotify
where stream > 1000000000 ;

--2  List all albums along with their respective artists.

Select album , artist
from spotify  ;

-- 3  Get the total number of comments for tracks where licensed = TRUE.
SELECT * FROM SPOTIFY
WHERE licensed = 'TRUE'; 

-- 4. Find all tracks that belong to the album type single.
SELECT * FROM SPOTIFY
WHERE ALBUM_TYPE = 'single';

-- 5.  Count the total number of tracks by each artist.
SELECT 
    artist,
	count (*) as  total_no_songs
from spotify 
Group by artist ;

--6.  Calculate the average danceability of tracks in each album.
SELECT 
    album,
    AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY avg_danceability DESC;
-- 7. Find the top 5 tracks with the highest energy values.
SELECT *
FROM spotify
ORDER BY energy DESC
LIMIT 5;

-- 8. List all tracks along with their views and likes where official_video = TRUE.
SELECT 
    track,
    views,
    likes
FROM spotify
WHERE official_video = TRUE;

-- 9. For each album, calculate the total views of all associated tracks.
SELECT 
    album,
    SUM(views) AS total_views
FROM spotify
GROUP BY album
ORDER BY total_views DESC;

-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT 
    track,
    stream,
    views
FROM spotify
WHERE stream > views;
SELECT * 
FROM spotify;
 -- Advanced Level
 
-- 11. Find the top 3 most-viewed tracks for each artist using window functions.
SELECT 
    artist,
    track,
    views
FROM (
    SELECT 
        artist,
        track,
        views,
        ROW_NUMBER() OVER (
            PARTITION BY artist 
            ORDER BY views DESC
        ) AS rank
    FROM spotify
    WHERE views IS NOT NULL
) AS ranked_tracks
WHERE rank <= 3;

-- 12. Write a query to find tracks where the liveness score is above the average.
SELECT 
    track,
    artist,
    liveness
FROM spotify
WHERE liveness > (
    SELECT AVG(liveness)
    FROM spotify
);
-- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH album_energy AS (
    SELECT 
        album,
        MAX(energy) AS highest_energy,
        MIN(energy) AS lowest_energy
    FROM spotify
    WHERE energy IS NOT NULL
    GROUP BY album
)

SELECT 
    album,
    highest_energy,
    lowest_energy,
    highest_energy - lowest_energy AS energy_difference
FROM album_energy
ORDER BY energy_difference DESC;