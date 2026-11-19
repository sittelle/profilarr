# DE-EN 1080p

Profilarr 2.3.1 or later, using Dictionarry schema 1.1.0. Apply the SQL operations in numeric order through Profilarr. Select and sync the desired profile and quality-size presets in the Radarr and Sonarr sync settings after updating.

The profile accepts HDTV-720p as a fallback, then HDTV-1080p, then 1080p WEB and Blu-ray. Other 720p qualities and 1080p remux remain disabled. Language scoring and size limits still apply.

## Validation

Python 3 with its standard library and network access to GitHub are required; no packages need to be installed. Run `python3 tests/verify.py` locally. It verifies pinned upstream schema checksums, applies all SQL with foreign keys enabled, and checks the resulting quality order and size limits. GitHub Actions runs the same command in the `verify` job on pushes and pull requests. There is no separate build or lint tool.
