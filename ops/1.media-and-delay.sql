-- Personal naming, media settings and delay presets for Profilarr 2.3.1.
-- Append-only addition; select each preset in the Arr instance's Sync page.

INSERT INTO radarr_naming
(name, rename, movie_format, movie_folder_format, replace_illegal_characters, colon_replacement_format)
VALUES
('Personal - Movies', 1,
'{Movie CleanTitle} {(Release Year)} {edition-{Edition Tags}} {[Quality Full]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{MediaInfo AudioLanguages}{[MediaInfo VideoDynamicRangeType]}{[Mediainfo VideoCodec]}{-Release Group}',
'{Movie CleanTitle} ({Release Year}) {tmdb-{TmdbId}}', 1, 'smart');

INSERT INTO sonarr_naming
(name, rename, standard_episode_format, daily_episode_format, anime_episode_format, series_folder_format, season_folder_format, replace_illegal_characters, colon_replacement_format, multi_episode_style)
VALUES
('Personal - Series', 1,
'{Series CleanTitleWithoutYear} {(Series Year)} - S{season:00}E{episode:00} - {Episode CleanTitle:90} {[Quality Full]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{MediaInfo AudioLanguages}{[MediaInfo VideoDynamicRangeType]}{[Mediainfo VideoCodec]}{-Release Group}',
'{Series CleanTitleWithoutYear} {(Series Year)} - {Air-Date} - {Episode CleanTitle:90} {[Quality Full]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{MediaInfo AudioLanguages}{[MediaInfo VideoDynamicRangeType]}{[Mediainfo VideoCodec]}{-Release Group}',
'{Series CleanTitleWithoutYear} {(Series Year)} - S{season:00}E{episode:00} - {absolute:000} - {Episode CleanTitle:90} {[Quality Full]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{MediaInfo AudioLanguages}{[MediaInfo VideoDynamicRangeType]}{[Mediainfo VideoCodec]}{-Release Group}',
'{Series TitleYear} {tvdb-{TvdbId}}', 'Season {season:00}', 1, 4, 5);

INSERT INTO radarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('Personal - Media Settings', 'preferAndUpgrade', 1);

INSERT INTO sonarr_media_settings (name, propers_repacks, enable_media_info)
VALUES ('Personal - Media Settings', 'preferAndUpgrade', 1);

INSERT INTO delay_profiles
(name, preferred_protocol, usenet_delay, torrent_delay, bypass_if_highest_quality, bypass_if_above_custom_format_score)
VALUES ('Personal - Usenet Only 60m', 'only_usenet', 60, NULL, 0, 0);

