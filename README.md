# DE-EN 1080p

Profilarr 2.3.1 or later, using Dictionarry schema 1.1.0. Apply the SQL operations in numeric order through Profilarr. Select and sync the desired profile and quality-size presets in the Radarr and Sonarr sync settings after updating.

The profile ranks 1080p above 720p. HDTV, WEBRip, WEB-DL and Blu-ray are equal within each resolution, with language scores deciding preference. 1080p remux remains disabled. Size limits still apply.

## Validation

Python 3 with its standard library and network access to GitHub are required; no packages need to be installed. Run `python3 tests/verify.py` locally. It verifies pinned upstream schema checksums, applies all SQL with foreign keys enabled, and checks the resulting quality order and size limits. GitHub Actions runs the same command in the `verify` job on pushes and pull requests. There is no separate build or lint tool.
