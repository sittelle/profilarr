-- Allow HDTV as a lower-priority option at each resolution. Keep the other
-- 720p sources disabled as configured in 4.automatic-1080p-dual.sql.
UPDATE quality_profile_qualities
SET position = CASE
    WHEN quality_name = 'HDTV-720p' THEN 0
    WHEN quality_group_name = '720p WEB + Blu-ray' THEN 1
    WHEN quality_name = 'HDTV-1080p' THEN 2
    WHEN quality_group_name = '1080p WEB + Blu-ray' THEN 3
    ELSE position + 4
END,
    enabled = CASE WHEN quality_name IN ('HDTV-720p', 'HDTV-1080p') THEN 1 ELSE enabled END
WHERE quality_profile_name = 'Personal - 1080p DE-EN';

UPDATE quality_profiles
SET description = '1080p preferred; HDTV-720p fallback. Recognised DE+EN > probable German dual audio > EN > DE within each quality.'
WHERE name = 'Personal - 1080p DE-EN';

-- Apply the existing size limits to the newly enabled qualities.
INSERT INTO radarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT name, REPLACE(quality_name, 'WEBDL-', 'HDTV-'), min_size, max_size, preferred_size
FROM radarr_quality_definitions
WHERE name = 'Personal - Film 133 MB-min' AND quality_name IN ('WEBDL-720p', 'WEBDL-1080p');

INSERT INTO sonarr_quality_definitions (name, quality_name, min_size, max_size, preferred_size)
SELECT name, REPLACE(quality_name, 'WEBDL-', 'HDTV-'), min_size, max_size, preferred_size
FROM sonarr_quality_definitions
WHERE name = 'Personal - Serie 100 MB-min' AND quality_name IN ('WEBDL-720p', 'WEBDL-1080p');
