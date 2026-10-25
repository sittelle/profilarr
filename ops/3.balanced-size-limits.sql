-- Profilarr 2.3.1: moderate runtime-based size limits.
-- Add as ops/3.balanced-size-limits.sql; keep earlier operations.
-- Works with either the original limits or the reduced limits from 2.size-limits.sql.
-- After Pull/Update select the renamed definitions in Arr > Sync:
-- Radarr: Personal - Film 105 MB-min
-- Sonarr: Personal - Serie 80 MB-min
-- Then Save and Sync. Minimum remains 10 MB/min.

UPDATE radarr_quality_definitions
SET name = 'Personal - Film 105 MB-min',
    max_size = 105,
    preferred_size = 104
WHERE name IN ('Personal - Film 133 MB-min', 'Personal - Film 80 MB-min');

UPDATE sonarr_quality_definitions
SET name = 'Personal - Serie 80 MB-min',
    max_size = 80,
    preferred_size = 79
WHERE name IN ('Personal - Serie 100 MB-min', 'Personal - Serie 60 MB-min');
