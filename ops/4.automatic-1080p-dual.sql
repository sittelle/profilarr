-- Profilarr 2.3.1 / schema 1.1.0
-- Add as ops/4.automatic-1080p-dual.sql after files 0 through 3.
-- Do NOT upload the earlier alternative 4.strict-1080p-dual.sql.
-- Ranking: recognised DE+EN (3000) > probable German dual (2500)
--          > recognised EN (2000) > recognised DE (1000).
-- Source bonuses remain +10/+20/+30. Unknown/no DE or EN stays rejected.
-- DL/ML/MULTI is evidence of another audio language, not proof of English.

INSERT INTO regular_expressions (name, pattern, description)
VALUES ('Personal - Dual Audio Marker',
        '(?i)(?<!WEB-)(?<!WEB\.)(?<!WEB_)(?<!WEB )(?<!WEB)\bDL\b|\b(?:ML|MULTI)\b',
        'Standalone DL, ML or MULTI; WEB-DL/WEB.DL/WEB_DL/WEB DL/WEBDL is not a dual-audio marker. Requires German language separately.');

INSERT INTO custom_formats (name, description, include_in_rename)
VALUES ('Personal - Probable German Dual',
        'German recognised, English NOT recognised, plus DL/ML/MULTI title marker. Probable dual audio only: second language may not be English. Never write a claimed language into the filename.', 0);

INSERT INTO custom_format_conditions (custom_format_name, name, type, negate, required)
VALUES ('Personal - Probable German Dual', 'German', 'language', 0, 1);
INSERT INTO condition_languages (custom_format_name, condition_name, language_name)
VALUES ('Personal - Probable German Dual', 'German', 'German');

INSERT INTO custom_format_conditions (custom_format_name, name, type, negate, required)
VALUES ('Personal - Probable German Dual', 'Not English', 'language', 1, 1);
INSERT INTO condition_languages (custom_format_name, condition_name, language_name)
VALUES ('Personal - Probable German Dual', 'Not English', 'English');

INSERT INTO custom_format_conditions (custom_format_name, name, type, negate, required)
VALUES ('Personal - Probable German Dual', 'Dual audio marker', 'release_title', 0, 1);
INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name)
VALUES ('Personal - Probable German Dual', 'Dual audio marker', 'Personal - Dual Audio Marker');

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
VALUES ('Personal - 1080p DE-EN', 'Personal - Probable German Dual', 'all', 1500);

UPDATE quality_profiles
SET description = '1080p only; recognised DE+EN > probable German dual audio (DL/ML/MULTI) > EN > DE. Automatic single-language fallback and later dual-audio upgrades.',
    minimum_custom_format_score = 1000,
    upgrade_until_score = 3030,
    upgrade_score_increment = 1,
    upgrades_allowed = 1
WHERE name = 'Personal - 1080p DE-EN';

UPDATE quality_profile_qualities
SET enabled = 0, upgrade_until = 0
WHERE quality_profile_name = 'Personal - 1080p DE-EN'
  AND quality_group_name = '720p WEB + Blu-ray';

-- Prevent native Proper/Repack priority from overriding language scores.
UPDATE radarr_media_settings SET propers_repacks = 'doNotPrefer'
WHERE name = 'Personal - Media Settings';
UPDATE sonarr_media_settings SET propers_repacks = 'doNotPrefer'
WHERE name = 'Personal - Media Settings';

-- Increase maxima while preserving the agreed preferred values.
UPDATE radarr_quality_definitions
SET name = 'Personal - Film 133 MB-min', max_size = 133, preferred_size = 104
WHERE name IN ('Personal - Film 133 MB-min', 'Personal - Film 80 MB-min',
               'Personal - Film 105 MB-min');

UPDATE sonarr_quality_definitions
SET name = 'Personal - Serie 100 MB-min', max_size = 100, preferred_size = 79
WHERE name IN ('Personal - Serie 100 MB-min', 'Personal - Serie 60 MB-min',
               'Personal - Serie 80 MB-min');
