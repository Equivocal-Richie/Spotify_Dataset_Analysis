/*
	** Let's clean & standardise the data first to be in a good format**
*/

/*
** Duplicate Logic: Duplicate = Same Song (Regardless of Album) **
An album can share the same name as the tracks eg "The Beattles

-- start_time = end_time - ms_played
*/
-- Check for duplicates in the data
WITH duplicate_cte AS (
    SELECT
        spotify_track_uri,
        ts AS end_time,
        DATE_ADD(ts, INTERVAL -ms_played / 1000.0 SECOND) AS start_time,  
        ROUND(ms_played / 60000.0, 2) AS duration,
        ROW_NUMBER() OVER (PARTITION BY spotify_track_uri, ts, platform, ms_played, track_name, reason_start, reason_end, shuffle, skipped ORDER BY ts) AS rn
    FROM spotify_data
)
SELECT * FROM duplicate_cte 
WHERE rn > 1;

-- Check for Null Vlaues
SELECT
    COUNT(*) AS total_rows,  -- Total number of rows in the table
    COUNT(CASE WHEN spotify_track_uri IS NULL OR spotify_track_uri = '' THEN 1 END) AS spotify_track_uri_nulls,
    COUNT(CASE WHEN ts IS NULL OR ts = '1970-01-01 00:00:00' THEN 1 END) AS ts_nulls,
    COUNT(CASE WHEN ms_played IS NULL OR ms_played = '' THEN 1 END) AS ms_played_nulls,
    COUNT(CASE WHEN platform IS NULL OR platform = '' THEN 1 END) AS platform_nulls,
    COUNT(CASE WHEN track_name IS NULL OR track_name = '' THEN 1 END) AS track_name_nulls,
    COUNT(CASE WHEN album_name IS NULL OR album_name = '' THEN 1 END) AS album_name_nulls,
    COUNT(CASE WHEN artist_name IS NULL OR artist_name = '' THEN 1 END) AS artist_name_nulls,  
    COUNT(CASE WHEN reason_start IS NULL OR reason_start = '' THEN 1 END) AS reason_start_nulls,
    COUNT(CASE WHEN reason_end IS NULL OR reason_end = '' THEN 1 END) AS reason_end_nulls,
    COUNT(CASE WHEN shuffle IS NULL OR shuffle = '' THEN 1 END) AS shuffle_nulls,
    COUNT(CASE WHEN skipped IS NULL OR skipped = '' THEN 1 END) AS skipped_nulls
FROM spotify_data;
/*
	Insights: The following columns have null values and along side the number present
    1. ms_played = 3,469
    2. reason_start = 143
    3. reason_end = 116
    4. shuffle = 37,066
    5. skipped = 140,494
*/

-- Create a new table to store the clean data
CREATE TABLE clean_spotify_data (
    spotify_track_url TEXT,
    start_time TIMESTAMP,
    end_time TIMESTAMP, -- Ensure it is stored as TIMESTAMP for proper time handling
    platform VARCHAR(255), 
    duration DECIMAL(10,2), -- Use DECIMAL for accurate decimal representation
    track_name VARCHAR(255),
    artist_name VARCHAR(255),
    album_name VARCHAR(255),
    reason_start VARCHAR(255), 
    reason_end VARCHAR(255),
    shuffle BOOLEAN, -- Use BOOLEAN data type 
    skipped BOOLEAN 
);


-- Insert cleaned data into the new table with data transformations
INSERT INTO clean_spotify_data (spotify_track_url, start_time, end_time, platform, duration, track_name, artist_name, album_name, reason_start, reason_end, shuffle, skipped)
SELECT 
    spotify_track_uri AS spotify_track_url, 
    DATE_ADD(ts, INTERVAL -COALESCE(ms_played, 0) / 1000.0 SECOND) AS start_time,  -- Handle ms_played NULLs
    ts AS end_time, 
    platform, 
    ROUND(COALESCE(ms_played, 0) / 60000.0, 2) AS duration, -- Handle ms_played NULLs
    track_name, 
    artist_name, 
    album_name, 
    NULLIF(reason_start, '') AS reason_start,  -- Handle reason_start empty strings (empty strings will be converted to NULL)
    NULLIF(reason_end, '') AS reason_end,    -- Handle reason_end empty strings (empty strings will be converted to NULL)
    COALESCE(shuffle, FALSE) AS shuffle,     -- Handle shuffle NULLs
    COALESCE(skipped, FALSE) AS skipped       -- Handle skipped NULLs
FROM spotify_data;  