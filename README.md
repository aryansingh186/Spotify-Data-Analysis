````markdown
# Spotify Data Analysis using PostgreSQL

> SQL-based data analysis project exploring Spotify tracks, artists, albums, streaming performance, YouTube engagement, and audio features.

---

## Project Overview

This project uses **PostgreSQL and SQL** to analyze a Spotify dataset and extract meaningful insights about music performance.

The analysis covers:

- Track and artist performance
- Album-level analysis
- Spotify streams
- YouTube views, likes, and comments
- Official music videos
- Audio features such as energy, danceability, and liveness
- Spotify vs YouTube performance

The project also demonstrates advanced SQL techniques including **Subqueries, CTEs, and Window Functions**.

---

## Objectives

- Identify highly streamed Spotify tracks
- Analyze the number of tracks by artist
- Compare album performance
- Analyze YouTube engagement
- Compare Spotify streams with YouTube views
- Find top-performing tracks for each artist
- Analyze audio characteristics of tracks
- Practice real-world SQL data analysis

---

## Tech Stack

| Technology | Usage |
|------------|-------|
| PostgreSQL | Database & Data Analysis |
| SQL | Data Cleaning & Analysis |
| pgAdmin 4 | Database Management |
| Git & GitHub | Version Control |

---

## Dataset

The dataset contains Spotify and YouTube-related information for music tracks.

### Important Columns

| Column | Description |
|--------|-------------|
| `artist` | Artist name |
| `track` | Track name |
| `album` | Album name |
| `album_type` | Album or single |
| `danceability` | Danceability score |
| `energy` | Energy level |
| `liveness` | Live-performance characteristics |
| `tempo` | Track tempo |
| `duration_min` | Track duration |
| `views` | YouTube views |
| `likes` | YouTube likes |
| `comments` | YouTube comments |
| `licensed` | Licensed content indicator |
| `official_video` | Official video indicator |
| `stream` | Spotify streams |

---

## Data Cleaning

The dataset was checked for invalid records before performing the analysis.

### Remove Zero-Duration Tracks

```sql
DELETE FROM spotify
WHERE duration_min = 0;
````

### Verify Records

```sql
SELECT *
FROM spotify
WHERE duration_min = 0;
```

This step ensures that invalid zero-duration tracks do not affect the analysis.

---

# Exploratory Data Analysis

## 1. Tracks with More Than 1 Billion Spotify Streams

**Business Question:** Which tracks have achieved more than 1 billion Spotify streams?

```sql
SELECT *
FROM spotify
WHERE stream > 1000000000;
```

---

## 2. Albums and Their Artists

**Business Question:** Which artists are associated with the albums in the dataset?

```sql
SELECT
    album,
    artist
FROM spotify;
```

---

## 3. Total Comments for Licensed Content

**Business Question:** What is the total YouTube comment count for licensed content?

```sql
SELECT
    SUM(comments) AS total_comments
FROM spotify
WHERE licensed = TRUE;
```

---

## 4. Tracks Released as Singles

**Business Question:** Which tracks were released as singles?

```sql
SELECT *
FROM spotify
WHERE album_type = 'single';
```

---

## 5. Number of Tracks by Artist

**Business Question:** Which artists have the highest number of tracks in the dataset?

```sql
SELECT
    artist,
    COUNT(*) AS total_no_songs
FROM spotify
GROUP BY artist
ORDER BY total_no_songs DESC;
```

**SQL Concepts:** `COUNT()`, `GROUP BY`, `ORDER BY`

---

# Album Analysis

## 6. Average Danceability by Album

**Business Question:** Which albums have the highest average danceability?

```sql
SELECT
    album,
    AVG(danceability) AS avg_danceability
FROM spotify
WHERE danceability IS NOT NULL
GROUP BY album
ORDER BY avg_danceability DESC;
```

**SQL Concepts:** `AVG()`, `GROUP BY`, `ORDER BY`

---

## 7. Top 5 Tracks by Energy-Liveness

**Business Question:** Which tracks have the highest energy-liveness values?

```sql
SELECT *
FROM spotify
WHERE energy_liveness IS NOT NULL
ORDER BY energy_liveness DESC
LIMIT 5;
```

---

## 8. Official Music Videos

**Business Question:** Which tracks have official music videos and how are they performing on YouTube?

```sql
SELECT
    artist,
    track,
    views,
    likes
FROM spotify
WHERE official_video = TRUE;
```

---

## 9. Total YouTube Views by Album

**Business Question:** Which albums have the highest total YouTube views?

```sql
SELECT
    album,
    SUM(views) AS total_views
FROM spotify
WHERE views IS NOT NULL
GROUP BY album
ORDER BY total_views DESC;
```

**SQL Concepts:** `SUM()`, `GROUP BY`, `ORDER BY`

---

# Spotify vs YouTube Analysis

## 10. Tracks Where Spotify Streams Exceed YouTube Views

**Business Question:** Which tracks have more Spotify streams than YouTube views?

```sql
SELECT
    artist,
    track,
    stream,
    views
FROM spotify
WHERE stream > views;
```

This comparison helps understand how the same track performs across different platforms.

---

# Advanced SQL Analysis

## 11. Top 3 Most-Viewed Tracks per Artist

**Business Question:** What are the top 3 most-viewed tracks for each artist?

```sql
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
WHERE rank <= 3
ORDER BY artist, views DESC;
```

**SQL Concepts:**

* `ROW_NUMBER()`
* `OVER()`
* `PARTITION BY`
* Subquery
* Ranking

---

## 12. Tracks with Above-Average Liveness

**Business Question:** Which tracks have a liveness score above the dataset average?

```sql
SELECT
    track,
    artist,
    liveness
FROM spotify
WHERE liveness > (
    SELECT AVG(liveness)
    FROM spotify
);
```

**SQL Concepts:** Subquery, `AVG()`, Conditional Filtering

---

## 13. Energy Difference Within Each Album

**Business Question:** Which albums have the largest difference between their highest and lowest energy tracks?

```sql
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
```

**SQL Concepts:** CTE, `MAX()`, `MIN()`, calculated columns

---

# SQL Concepts Used

### Data Manipulation

* `SELECT`
* `DELETE`
* `WHERE`
* `ORDER BY`
* `LIMIT`

### Aggregation

* `COUNT()`
* `SUM()`
* `AVG()`
* `MAX()`
* `MIN()`
* `GROUP BY`

### Advanced SQL

* Subqueries
* Common Table Expressions (CTEs)
* Window Functions
* `ROW_NUMBER()`
* `PARTITION BY`
* Conditional Filtering
* Calculated Columns

---

# Key Insights

The analysis helps identify several patterns within the dataset:

* Highly streamed tracks can be identified using Spotify stream counts.
* Artist representation varies based on the number of tracks available in the dataset.
* Album performance can be analyzed through YouTube views and audio characteristics.
* Spotify streams and YouTube views provide different measures of track popularity.
* Official music videos can be evaluated using views and likes.
* Window functions make it possible to identify the top tracks within each artist.
* Audio features such as danceability, energy, and liveness provide additional dimensions for music analysis.

> Exact numerical findings can be added from the final SQL query results.

---

# Business Questions Answered

| Area                | Analysis                                   |
| ------------------- | ------------------------------------------ |
| Track Performance   | Tracks with 1B+ Spotify streams            |
| Artist Analysis     | Number of tracks by artist                 |
| Album Analysis      | Danceability and YouTube views             |
| YouTube Analysis    | Views, likes, comments and official videos |
| Platform Comparison | Spotify streams vs YouTube views           |
| Ranking             | Top 3 tracks per artist                    |
| Audio Analysis      | Energy and liveness                        |
| Content Analysis    | Licensed content and singles               |

---

# Project Workflow

```text
Raw Dataset
     ↓
PostgreSQL Database
     ↓
Data Cleaning
     ↓
Exploratory Data Analysis
     ↓
Aggregation & Comparison
     ↓
Advanced SQL Analysis
     ↓
Business Insights
```

---

# Future Scope

* Build an interactive **Power BI dashboard**
* Add time-based music performance analysis
* Create artist and album performance KPIs
* Analyze Spotify and YouTube engagement together
* Add more advanced SQL queries
* Automate the data cleaning and analysis pipeline

---

# Repository Structure

```text
Spotify-Data-Analysis/
│
├── README.md
├── spotify_analysis.sql
└── data/
    └── spotify.csv
```

---

# Conclusion

This project demonstrates the use of **PostgreSQL and SQL for practical data analysis**.

It covers the complete analysis process from **data cleaning and exploratory analysis to advanced SQL techniques**, including subqueries, CTEs, and window functions.

The project can further be extended into a **Power BI dashboard** to present the findings through interactive visualizations.

---

## Author

**Aryan Singh**

B.Tech Computer Science Engineering

**Skills:** SQL | PostgreSQL | Python | Power BI | Data Analytics

```

Ye version intentionally **simple aur consistent** rakha hai. GitHub par isme headings, tables aur SQL sections ek hi visual pattern follow karenge, isliye previous version jaisa mismatch feel nahi aayega.
```
