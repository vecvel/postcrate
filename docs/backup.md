# Backup

Postcrate backs up to a single file and never talks to a server. The user picks where the file goes from the system share sheet: Save to Files, the Google Drive or iCloud Drive app, AirDrop, email, a computer. No accounts, API keys or cloud setup are needed.

## Making a backup

Backup tab → **Create backup**. Postcrate packs everything into `Postcrate backup YYYY-MM-DD.zip` and opens the share sheet. When the user saves or sends it, the app records the time. The Backup tab and Home show when the last backup was made and how many posts changed since.

## Restoring

Backup tab → **Choose backup file**, then pick:

- **Everything**, or
- **Only posts made on** one or more days (the list shows each day in the backup with its post count).

Posts missing on the phone are added. A post that exists in both is replaced only when the backup copy was edited more recently. Nothing is deleted. Collections are matched by name. Reminders are rescheduled afterwards.

## File format

A standard zip, readable with any unzip tool:

| Entry | Contents |
|---|---|
| `postcrate.json` | `{format: "postcrate.backup", version: 2, createdAt, platform, posts: [...], collections: [...]}`. Posts use the same JSON as `Post.toJson()`: text, thread, link, poll, hashtags, mentions, place, language, content warning, first comment, reminder, targets and per-app text, status, pinned, notes, share history with live links, and attachments with their media info. |
| `media/SHA256.ext` | Each attachment once, named by its content hash, stored without recompression. |

Zipping and unzipping run in a background isolate and stream files from disk, so large videos don't freeze the app or need to fit in memory. Preview frames aren't included; they're rebuilt from the media after a restore.
