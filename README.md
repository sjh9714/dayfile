# Dayfile

A journal in a folder of Markdown files you own. Three things set it apart:
each day drafts itself from the traces you already left (git commits, calendar,
photos); the memory your agent builds from it records not only what is true
but since when and when the journal learned it; and nothing is behind an
account or a subscription.

![Dayfile demo: a drafted day, the entry, memory over time, and an agent answering from the journal over MCP](docs/demo.gif)

## Why

Journals die because writing every day is work. Agents forget you because
their memory lives in someone else's cloud, in a form you cannot read or fix.
Dayfile does both jobs with one folder. Day One has an agent connector too, on
Mac with a subscription, against its own database; Dayfile's version is a
folder you can open, diff, sync and correct, and it is the only one that reads
your commits.

- **A day that writes its first draft.** Point it at your code folders, a
  calendar feed and a photo folder. When you open the app (or at your
  reminder time) it drafts today: meetings, what you committed, where the
  photos were taken. You add a line about how it went and keep it, or discard
  it. Nothing runs in the background and nothing is read that you did not list.
- **Memory with a timeline.** Your agent pulls durable facts out of entries
  (where you live, who people are, what you are working on) into
  `memory/<topic>.md`. Facts are never overwritten. A new fact ends the old
  one, so "where did I live in 2023?" and "what did the journal believe last
  month?" both have answers, and every fact links to the entry it came from.
  You can open the file and correct it.
- **Plain files.** One `.md` per entry with YAML frontmatter, photos in a
  content-addressed folder, memory as readable YAML. Sync with iCloud Drive,
  Dropbox, Syncthing or git. The SQLite index is a cache rebuilt from the
  files. See [`docs/format.md`](docs/format.md).
- **A real journal app.** Timeline, calendar, On This Day, full-text search
  (works for Korean, Japanese, Chinese), tags, templates, a passcode screen,
  a reminder, a trash with Undo, and Day One import.

## Install

Desktop app: download the build for macOS, Windows or Linux from
[Releases](https://github.com/sjh9714/dayfile/releases). The macOS builds are
signed and notarized.

CLI (also the MCP server):

```sh
brew install --cask sjh9714/tap/dayfile   # macOS; or grab a binary from Releases
dayfile init                              # creates ~/Journal (or follows the app's folder)
```

## Draft your day

```sh
dayfile sources add git ~/code
dayfile sources author you@example.com      # only your commits
dayfile sources add calendar "https://calendar.google.com/calendar/ical/…/basic.ics"
dayfile sources add photos ~/Pictures/Phone
dayfile capture                             # today's draft
dayfile drafts                              # what waits for review
dayfile keep <id>                           # or discard it: `dayfile delete <id>`
```

A draft looks like this, and stays out of the timeline, search and stats until
you keep it:

```markdown
Standup +1, 4 commits to shop-api, 3 photos

- 09:30–09:45 · Standup
- 10:12–16:40 · shop-api · 4 commits (Add order endpoint; Fix refund rounding; +2 more)
- 19:00–21:00 · Algorithms study
- 18:20–18:41 · 3 photos
```

Capturing the same day again only adds what is new. The app does the same from
Settings → Capture.

## Let your agent in

```sh
claude mcp add dayfile -- dayfile mcp serve
```

Claude Desktop: download the `.mcpb` file from Releases and open it.

The server has 19 tools and two prompts. Run the `review_day` prompt in the
evening: the agent captures the day, asks you a couple of questions, writes the
entry in your words, and records what it learned in memory. Then ask things
like "what did I work on last week?", "when did I move to Seoul?", or "summarise
my month". `--read-only` if you only want it to read. Details in
[`docs/mcp.md`](docs/mcp.md).

## Memory from the shell

```sh
dayfile remember Home "Lives in Seoul" --since 2024-03-01 --replaces f3a9c2e1
dayfile recall --topic home --as-of 2023-06-01      # Lives in Busan
dayfile history Home
dayfile topics
```

## Everyday journaling

```sh
dayfile add "First entry" -t life
dayfile add --template gratitude
dayfile search river
dayfile on-this-day
dayfile stats
dayfile delete <id>                # to the trash; `dayfile trash restore <id>` undoes it
```

## Import from Day One

Day One → Export → JSON. Then in the app: Settings → Import Day One export,
or:

```sh
dayfile import dayone ~/Downloads/Export.zip
```

Entries, photos, tags, location, weather and stars come across. Re-importing
never duplicates.

## On your phone

There is no mobile app yet. Because entries are plain Markdown files, keep
the journal folder in iCloud Drive (or Dropbox, Syncthing) and open it with
any Markdown editor on the phone. On iPhone, [Obsidian](https://obsidian.md)
(free) works well: create a vault, choose "Existing folder", pick the journal
folder in iCloud Drive, and new entries follow the format in
[`docs/format.md`](docs/format.md). The desktop app picks the edits up the
next time it is focused.

## Privacy

No account, no server, no telemetry. Capture reads only the folders and feeds
you list, only when you or your agent ask (or at app launch and the reminder).
A git source covers every repository under that folder (four levels deep),
your own commits only, so keep work repositories out of the folders you list
if their commit messages should not reach the journal or the agent you review
it with. Calendar and git sources stay in the app's config on this machine,
not in the synced folder. Optional location and weather for new entries use the OS
location service or a city-level guess from ipapi.co, then Open-Meteo; one
toggle turns that off.

## Build from source

```sh
(cd apps/desktop && npm install)
scripts/check.sh                       # tests, clippy, web build
cd apps/desktop && npm run tauri build
```

## Status and limitations

Desktop app (macOS, Windows, Linux), CLI, MCP, capture from git, calendars and
photos, bi-temporal memory, Day One import. Not yet: mobile, built-in sync,
encryption at rest, more capture sources (shell history, browser).

Know these before you rely on it:

- The passcode screen hides the app. It does not encrypt anything; the files
  stay plain text on disk.
- An agent's `update_entry` replaces the body and there is no undo for it
  (deletes go to the trash, edits do not). Keep the journal folder in git or
  a synced folder with version history if agents may write to it, or pass
  `--read-only`.
- Windows and Linux builds come from CI and have not been tried on real
  hardware.

MIT. "Day One" is a trademark of Automattic; this project only reads its
export format.
