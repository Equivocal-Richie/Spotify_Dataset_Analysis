/*
	** Initial Analysis of the Data! **
I'm getting to understand what I'm working with as I get more clues 
to investigate afterwards.
*/
-- Let's see the number of rows imported  
SELECT COUNT(*) FROM spotify_data;

-- Check the Number of Rows Imported
SELECT COUNT(*) AS No_Rows
FROM spotify_data;

-- Check the description of the table
DESCRIBE spotify_data;

-- Let's check the number of unique values in the 'spotify_track_uri' column
SELECT COUNT(DISTINCT spotify_track_uri) AS unique_spotify_track_uri
FROM spotify_data; -- output: 16,527

-- Check the number of unique tracks in the data
SELECT COUNT(DISTINCT track_name) AS unique_tracks
FROM spotify_data; -- output: 13,643

-- Check the number of albums
SELECT COUNT(album_name) FROM spotify_data; -- output: 148,350
-- Number of unique albums
SELECT COUNT(DISTINCT album_name) FROM spotify_data; -- output: 7,896

-- Let's view the unique values in 'artist_name' column data 
SELECT DISTINCT artist_name FROM spotify_data;
-- Count of unique artists
SELECT COUNT(DISTINCT artist_name) FROM spotify_data; -- output: 4,112

-- Check the distinct platforms listeners use
SELECT DISTINCT platform
FROM spotify_data; -- output: 6 unique platforms (android, mac, cast to device, iOS, windows, & web player)

-- Check the number of 'TRUE' and 'FALSE' values in 'shuffle'
SELECT
	ROUND(
    SUM(shuffle = 1)/COUNT(shuffle) * 100
    , 2) AS True_percentage,
    ROUND(
    SUM(shuffle = 0)/COUNT(shuffle) * 100
    , 2) AS False_percentage
FROM spotify_data; -- output: True(75.01%) & False(24.99%)
-- Shows that most listeners stream their music on shuffle mode.


-- Check the number of 'TRUE' and 'FALSE' values in 'skipped'
SELECT
	ROUND(
    SUM(skipped = 1)/COUNT(skipped) * 100
    , 2) AS True_percentage,
    ROUND(
    SUM(skipped = 0)/COUNT(skipped) * 100
    , 2) AS False_percentage
FROM spotify_data; -- output: True(5.30%) & False(94.70)
-- Shows that most users don't skip songs that they're streaming

-- Check for unique 'reason_end' values and the number of times each happened
SELECT DISTINCT reason_end, COUNT(reason_end) AS No_Occasions
FROM spotify_data
GROUP BY reason_end
ORDER BY No_Occasions DESC;  -- order from the highest to the lowest
-- Insights: I've found a blank space with no name but has 116 values 

-- Check for unique 'reason_start' values and the number of times each happened
SELECT DISTINCT reason_start, COUNT(reason_end) AS No_Occasions
FROM spotify_data
GROUP BY reason_start
ORDER BY No_Occasions DESC;  -- order from the highest to the lowest
-- Insights: I've found a blank space with no name but has 143 values 

-- Check the number of years in the timestamp 'ts' column
SELECT DISTINCT EXTRACT(YEAR FROM ts) AS Years
FROM spotify_data
ORDER BY Years DESC; -- order from the latest year to the oldest
-- Insights: Data contains values from 2013-2024
-- Further analysis: We can visualize ranking of the number of tracks listened in each year

