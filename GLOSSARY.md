# Dayfile

A journal whose days draft themselves from what the user already left behind, and which becomes long-term memory their agent can read. This glossary names the concepts the app, the CLI, the agent tools and the docs share.

## The journal

**Journal**:
The folder a user owns that holds everything: entries, attachments, templates and memory.
_Avoid_: Vault, store, library

**Notebook**:
A named group of entries inside a journal. A journal can hold several.
_Avoid_: Journal (for the group)

**Entry**:
One piece of writing, dated by the moment and timezone it belongs to.
_Avoid_: Post, note, diary page

**Attachment**:
A file an entry refers to, such as a photo.
_Avoid_: Media, asset

**Template**:
A reusable starting text for a new entry.

**Trash**:
Where deleted entries wait to be restored or to expire.

## Drafted days

**Capture**:
Gathering what happened on one day from the sources into a draft, only when asked or when the app opens or reminds.
_Avoid_: Sync, import, collect

**Source**:
A place the user listed for capture to read: a code folder, a calendar feed or a photo folder.
_Avoid_: Connector, integration

**Trace**:
One thing a source recorded, such as a commit, a calendar event or a photo, which is captured at most once.
_Avoid_: Event, activity, item

**Draft**:
An entry made by capture that waits for review and stays out of the timeline, search and stats.
_Avoid_: Pending entry, suggestion

**Review**:
The moment a draft gets the user's own words and their decision, alone or with an agent's help.

**Keep**:
Turning a draft into an ordinary entry.
_Avoid_: Accept, approve, publish

**Discard**:
Rejecting a draft, so that its traces are not captured again unless it is restored from the trash.
_Avoid_: Dismiss, reject

## Memory

**Memory**:
Everything the journal holds as facts about the user's life, as opposed to the entries they wrote.
_Avoid_: Knowledge base, profile

**Topic**:
A named subject that facts are grouped under, the same topic regardless of letter case.
_Avoid_: Category, tag

**Fact**:
One statement about the user's life, with when it was true and when the journal learned it. Without a stated start, it holds from the day it was recorded.
_Avoid_: Memory (for a single item), note

**Source entry**:
The entry a fact came from. Distinct from a source, which feeds capture.

**End**:
What a newer fact does to an older one that was true and no longer is. The older fact stays on record, and it cannot end before its stated start.
_Avoid_: Overwrite, update, close

**Retract**:
Marking a fact as never having been true. It stays on record and leaves every answer.
_Avoid_: Delete, remove

**As of**:
The date in the world a question is about.
_Avoid_: Valid time

**Known at**:
The moment in the journal's own history a question is asked from.
_Avoid_: Transaction time
