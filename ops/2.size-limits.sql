-- Profilarr 2.3.1: reduced runtime-based size limits.
-- Add as ops/2.size-limits.sql alongside the existing ops files.
-- After Pull/Update, select the NEW preset names in each Arr instance's Sync page:
-- Radarr: Personal - Film 80 MB-min
-- Sonarr: Personal - Serie 60 MB-min
-- Save and Sync the relevant section. Do not replace 0.personal.sql.
-- Minimum remains 10 MB/min; preferred remains just below maximum.

UPDATE radarr_quality_definitions
SET name = 'Personal - Film 80 MB-min',
    max_size = 80,
    preferred_size = 79
WHERE name = 'Personal - Film 133 MB-min';

UPDATE sonarr_quality_definitions
SET name = 'Personal - Serie 60 MB-min',
    max_size = 60,
    preferred_size = 59
WHERE name = 'Personal - Serie 100 MB-min';
