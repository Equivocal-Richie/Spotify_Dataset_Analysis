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
    COUNT(CASE WHEN spotify_track_uri IS NULL THEN 1 END) AS spotify_track_uri_nulls,
    COUNT(CASE WHEN ts IS NULL THEN 1 END) AS ts_nulls,
    COUNT(CASE WHEN ms_played IS NULL THEN 1 END) AS ms_played_nulls,
    COUNT(CASE WHEN platform IS NULL THEN 1 END) AS platform_nulls,
    COUNT(CASE WHEN track_name IS NULL THEN 1 END) AS track_name_nulls,
    COUNT(CASE WHEN album_name IS NULL THEN 1 END) AS album_name_nulls,
    COUNT(CASE WHEN artist_name IS NULL THEN 1 END) AS artist_name_nulls,  
    COUNT(CASE WHEN reason_start IS NULL THEN 1 END) AS reason_start_nulls,
    COUNT(CASE WHEN reason_end IS NULL THEN 1 END) AS reason_end_nulls,
    COUNT(CASE WHEN shuffle IS NULL THEN 1 END) AS shuffle_nulls,
    COUNT(CASE WHEN skipped IS NULL THEN 1 END) AS skipped_nulls
FROM spotify_data;


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
    reason_start VARCHAR(255), -- Allow for potential longer reason descriptions
    reason_end VARCHAR(255),
    Shuffle BOOLEAN, -- Use BOOLEAN data type if supported by your MySQL version
    Skipped BOOLEAN 
);


-- Insert data into the new table with data transformations
INSERT INTO clean_spotify_data
SELECT 
    spotify_track_uri AS spotify_track_url, 
    DATE_ADD(ts, INTERVAL -ms_played / 1000.0 SECOND) AS start_time,
    ts AS end_time, 
    platform, 
    ROUND(ms_played / 60000.0, 2) AS duration, -- Calculate minutes played
    track_name, 
    artist_name, 
    album_name, 
	reason_start, 
	reason_end, 
    shuffle, 
    skipped
FROM 
    spotify_data;
    
       