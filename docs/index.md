---
titleTemplate: :title # also VitePress config
---

# zsh-job-queue

![GitHub release (latest v2)](https://img.shields.io/github/v/release/olets/zsh-job-queue?filter=v2.*)

![splash card: the text '% zsh job queue' in a descending, fading waterfall](/zsh-job-queue-card.png)

**zsh-job-queue** manages global (cross-terminal) synchronous job queues.

It's useful if you you have a script that destructively modifies a file and you want to support running the script in multiple terminals in quick succession.

That's is a real need I have. [zsh-abbr](https://zsh-abbr.olets.dev), my zsh manager for auto-expanding abbreviations, has common operations in which file contents are read, parsed, and modified, and the modified contents are written back to the file. Notably this happens when a user uses the zsh-abbr CLI to manage abbreviations, and when a new session is started. Without a cross-terminal job queue, it would be possible to mistime the actions (for example if a terminal was delayed but some OS process) and lose data. zsh-job-queue is not infallible, but in practice it's pretty close; and when something does go wrong, the console logs help users determine whether it was user error or a bug.
