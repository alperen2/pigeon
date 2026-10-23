# Usage

## Quick capture

1. Press the global shortcut
2. Type thought
3. Press Enter

### Notes under a task

Press Shift-Return to start a new line. The first line is the task; the lines below are its description, for details or a short checklist. In the file they are indented under the task:

```md
- [ ] 14:02 Send the report #work id:a1b2c3d4
  - add Q3 numbers
  - CC the team
```

Only the first line is read for `@project`, `#tag`, `!priority` and `due:`. Click a description to open the task on its own, with the whole note at a readable size. Edit it there: Return starts a new line and ⌘Return saves. From a row's title editor, Shift-Return opens the note. A blank line ends the description, so blank lines inside it are not kept.

## Today list

Inside spotlight panel, manage today's items quickly:

- toggle done/undone
- edit
- delete + undo
- use the circled calendar button next to quick capture to open the larger calendar view with quick day/week/month jumps

## Pigeon Syntax

Pigeon uses a powerful, natural language-friendly syntax to organize your thoughts instantly:

### Projects & Context
- `@ProjectName` — Routes the task to the project's own folder instead of the daily inbox. Project entries use the same dated file naming as the inbox (e.g., `ProjectName/2026-02-27.md`).

### Priorities
- `!1` — High Priority
- `!2` — Medium Priority
- `!3` — Low Priority

### Tags
- `#tagname` — Adds a tag to the task for easy filtering and organization.

### Dates & Time (Key-Value)
- `due:date` — Sets a deadline. Supports natural phrases like `due:next friday`, `due:end of month`, `due:in 2 weeks`, plus shorthands like `tdy`, `tmr`, `nw`, and `eow`.
- `defer:date` or `start:date` — Hides the task from your inbox until the specified date arrives (examples: `defer:next monday`, `start:in 3 days`).
- `time:duration` or `dur:duration` — Sets a planned duration (e.g., `15m`, `2h`, `1d`) and updates the right-side planned time range.
- `remind:duration` or `alarm:duration` — Sets a notification alert.

Natural language date parsing is intentionally limited to `due:`, `defer:`, and `start:` values to keep behavior deterministic and distraction-free.

### Interactive Features
When typing `@`, `#`, or keywords like `due:` and `time:`, Pigeon provides an **interactive autocomplete menu**.
* **Smart Previews:** The menu shows exactly what time or date a shorthand or phrase (like `eow` or `next friday`) resolves to.
* **Clickable Pills:** You can click on the generated metadata pills in your task list to quickly edit values or remove them without manual text editing.

## Menubar utility

Use menu actions for:

- Open Today File
- Open Inbox Folder
- Settings
