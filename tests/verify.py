"""Apply all operations to the pinned upstream schema and check the resulting profile."""
import hashlib
import json
import pathlib
import sqlite3
import urllib.request

ROOT = pathlib.Path(__file__).resolve().parent.parent
SCHEMA = {
    '0.schema.sql': '1658b02741f7cdd9358f828bebe693ffc222211d3f13b8af02e4fb431755d0de',
    '1.languages.sql': 'b2cb29ee82c40585bae7c308a1da1683faabd5f7a2758b3904dcac3cace062e5',
    '2.qualities.sql': '399b99295f2def676c61064496f793e0be71531108c3febfe039607034148c5e',
    '3.quality-group-member-position.sql': '8a1cc4a55adc62caed9d2acc69f0d684deae942847f6984732f70d2fc23d4b0b',
}
manifest = json.loads((ROOT / 'pcd.json').read_text())
assert manifest['dependencies']['https://github.com/Dictionarry-Hub/schema'] == '1.1.0'
con = sqlite3.connect(':memory:')
con.execute('PRAGMA foreign_keys = ON')
for name, digest in SCHEMA.items():
    url = f'https://raw.githubusercontent.com/Dictionarry-Hub/schema/1.1.0/ops/{name}'
    with urllib.request.urlopen(url, timeout=30) as response:
        content = response.read()
    if hashlib.sha256(content).hexdigest() != digest:
        raise ValueError(f'Unexpected checksum for {name}')
    con.executescript(content.decode())
for path in sorted((ROOT / 'ops').glob('*.sql')):
    con.executescript(path.read_text())
rows = con.execute("""SELECT COALESCE(quality_name, quality_group_name), position, enabled, upgrade_until
                      FROM quality_profile_qualities WHERE quality_profile_name = 'Personal - 1080p DE-EN'""").fetchall()
quality = {name: (position, enabled, cutoff) for name, position, enabled, cutoff in rows}
assert len({row[1] for row in rows}) == len(rows), 'Duplicate quality positions'
assert quality['720p'][1:] == (1, 0)
assert quality['1080p'][1:] == (1, 1)
assert quality['720p'][0] < quality['1080p'][0]
assert quality['Remux-1080p'][1] == 0
for resolution in ('720p', '1080p'):
    members = {row[0] for row in con.execute(
        "SELECT quality_name FROM quality_group_members WHERE quality_profile_name = ? AND quality_group_name = ?",
        ('Personal - 1080p DE-EN', resolution))}
    assert members == {f'HDTV-{resolution}', f'WEBRip-{resolution}', f'WEBDL-{resolution}', f'Bluray-{resolution}'}
source_scores = con.execute("""SELECT score FROM quality_profile_custom_formats
    WHERE quality_profile_name = 'Personal - 1080p DE-EN' AND custom_format_name LIKE 'Personal - Source %'""").fetchall()
assert len(source_scores) == 3 and all(score == 0 for (score,) in source_scores)
assert con.execute("SELECT upgrade_until_score FROM quality_profiles WHERE name = 'Personal - 1080p DE-EN'").fetchone() == (3000,)
for table, preset in [('radarr_quality_definitions', 'Personal - Film 133 MB-min'),
                      ('sonarr_quality_definitions', 'Personal - Serie 100 MB-min')]:
    for resolution in ('720p', '1080p'):
        values = con.execute(f'SELECT quality_name, min_size, max_size, preferred_size FROM {table} WHERE name = ? AND quality_name IN (?, ?)',
                             (preset, f'HDTV-{resolution}', f'WEBDL-{resolution}')).fetchall()
        assert len(values) == 2 and values[0][1:] == values[1][1:], (table, resolution, values)
print('Schema, operations, quality ordering and size limits verified.')
