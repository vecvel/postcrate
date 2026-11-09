# Changelog

All notable changes to this project are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project uses [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.0.2]

### Added

- Save to Postcrate from other apps' share sheets: photos, videos, audio, documents, links and text become a new post or are added to an existing one. iOS gets a share extension; Android accepts files as well as text.

### Changed

- A post link shared into Postcrate is offered for attaching only while a recent share is waiting for one; otherwise it is saved like any other link.

## [1.0.1]

### Fixed

- Removed the empty space at the bottom of the post editor.
- The apps a post is planned for now sit in one row that scrolls sideways.

## [1.0.0]

### Added

- Posts with title, text, thread parts, media, link preview, poll, hashtags, mentions, location, language, content warning, first comment, reminder, per-app text, collections, status, pinning and private notes.
- Sharing to installed apps through the system share sheet, with the caption copied to the clipboard for apps that drop it, and direct composer links for text-only posts.
- Share history and post link capture from the clipboard or from links shared into the app (Android).
- Media details for attachments: codecs, resolution, duration, frame rate, bitrate, audio, color, pages and file size, with video and PDF previews.
- Video checks against the length and size limits of the apps a post is going to, including Shorts and Reels.
- Reminder notifications.
- Backup to a single zip file and restore of everything or selected days.
- Light and dark themes.
