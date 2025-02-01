/*
Initial Analysis of the Data!
*/
-- Let's view the 1st 10 rows 
SELECT * FROM spotify_data
LIMIT 10;

-- Check the Number of Rows Imported
SELECT COUNT(*) AS No_Rows
FROM spotify_data;

-- Check the number of unique tracks in the data
SELECT COUNT(DISTINCT track_name) AS unique_tracks
FROM spotify_data; -- output: 13,643

-- Check the distinct platforms listeners use
SELECT DISTINCT platform
FROM spotify_data; -- output: 6 unique platforms (android, mac, cast to device, iOS, windows, & web player)

