/*
	** Let's clean & standardise the data first to be in a good format**
*/
-- Step 1: Handle missing values
UPDATE spotify_data
SET platform = 'Unknown'
WHERE platform IS NULL OR platform = 'NULL';

UPDATE spotify_data
SET ms_played = 0
WHERE ms_played IS NULL;

UPDATE spotify_data
SET track_name = 'Unknown'
WHERE track_name IS NULL;

UPDATE spotify_data
SET reason_start = 'undefined'
WHERE reason_start IS NULL;

UPDATE spotify_data
SET reason_end = 'undefined'
WHERE reason_end IS NULL;

-- Step 2: Remove duplicates
DELETE t1
FROM spotify_data t1
INNER JOIN spotify_data t2
WHERE
    t1.spotify_track_uri = t2.spotify_track_uri AND
    t1.ts = t2.ts;

-- Step 3: Standardize date formats
UPDATE spotify_data
SET ts = STR_TO_DATE(ts, '%Y-%m-%d %H:%i:%s');

-- Step 4: Remove invalid data (negative values)
DELETE FROM spotify_data
WHERE ms_played < 0;

-- Step 5: Trim whitespace
UPDATE spotify_data
SET track_name = TRIM(track_name),
    artist_name = TRIM(artist_name),
    album_name = TRIM(album_name),
    platform = TRIM(platform),
    reason_start = TRIM(reason_start),
    reason_end = TRIM(reason_end);