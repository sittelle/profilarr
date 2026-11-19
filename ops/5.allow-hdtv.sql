-- Treat HDTV, WEB and Blu-ray as equal within each resolution.
DELETE FROM quality_profile_qualities
WHERE quality_profile_name = 'Personal - 1080p DE-EN'
  AND quality_name IN ('HDTV-720p', 'HDTV-1080p');

INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position)
VALUES ('Personal - 1080p DE-EN', '720p WEB + Blu-ray', 'HDTV-720p', 3),
       ('Personal - 1080p DE-EN', '1080p WEB + Blu-ray', 'HDTV-1080p', 3);

UPDATE quality_groups SET name = '720p'
WHERE quality_profile_name = 'Personal - 1080p DE-EN' AND name = '720p WEB + Blu-ray';
UPDATE quality_groups SET name = '1080p'
WHERE quality_profile_name = 'Personal - 1080p DE-EN' AND name = '1080p WEB + Blu-ray';

UPDATE quality_profile_qualities SET enabled = 1
WHERE quality_profile_name = 'Personal - 1080p DE-EN' AND quality_group_name = '720p';

-- Source bonuses must not override or break ties in language scores.
UPDATE quality_profile_custom_formats SET score = 0
WHERE quality_profile_name = 'Personal - 1080p DE-EN'
  AND custom_format_name IN ('Personal - Source webrip', 'Personal - Source web_dl', 'Personal - Source bluray');

UPDATE quality_profiles
SET description = '1080p > 720p; equal sources within each resolution. Recognised DE+EN > probable German dual audio > EN > DE.',
    upgrade_until_score = 3000
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
