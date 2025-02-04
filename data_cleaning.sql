/*
	** Let's clean & standardise the data first to be in a good format**
*/
-- Create a new table to store the clean data
CREATE TABLE clean_spotify_data (
    spotify_track_url TEXT,
    ts TIMESTAMP, -- Ensure ts is stored as TIMESTAMP for proper time handling
    platform VARCHAR(255), 
    ms_played_minutes DECIMAL(10,2), -- Use DECIMAL for accurate decimal representation
    track_name VARCHAR(255),
    artist_name VARCHAR(255),
    album_name VARCHAR(255),
    reason_start VARCHAR(255), -- Allow for potential longer reason descriptions
    reason_end VARCHAR(255),
    Shuffle BOOLEAN, -- Use BOOLEAN data type if supported by your MySQL version
    Skipped BOOLEAN 
);


-- View the original data 
SELECT * FROM spotify_data
LIMIT 5;


-- Insert data into the new table with data transformations
INSERT INTO clean_spotify_data
SELECT 
    spotify_track_uri AS spotify_track_url, 
    ts, 
    platform, 
    ROUND(ms_played / 60000.0, 2) AS ms_played_minutes, -- Calculate minutes played
    track_name, 
    artist_name, 
    album_name, 
    CASE 
        WHEN reason_start = '' THEN NULL 
        ELSE reason_start 
    END AS reason_start, 
    CASE 
        WHEN reason_end = '' THEN NULL 
        ELSE reason_end 
    END AS reason_end, 
    CASE 
        WHEN shuffle = 1 THEN TRUE 
        ELSE FALSE 
    END AS Shuffle, 
    CASE 
        WHEN skipped = 1 THEN TRUE 
        ELSE FALSE 
    END AS Skipped
FROM 
    spotify_data;