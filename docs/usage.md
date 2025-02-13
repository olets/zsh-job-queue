# Usage

## Quick start

1. Join the `<scope>`'s queue in that place, and pause to wait for the job's turn: `job-queue push <scope>`.
2. Do some work.
3. End the job you started: `job-queue pop <scope> <id output by push command>`.

These should be done in immediate succession, like so:

```shell
id=$(job-queue push my-scope)

# do work here

job-queue pop my-scope $id
```

::: danger Time constraint
A job is considered to have timed out if it is not `pop`ped within `JOB_QUEUE_TIMEOUT_AGE_SECONDS` seconds (docs: [Options](/options)) of being `push`ed.
:::

## Commands

### `help`

```shell
job-queue (help | --help)
```

Show the manpage.

If the package is installed with Homebrew, `man job-queue` is also available.

### `pop`

```shell
job-queue pop <scope> <id>
```

Take a job out of the `<scope>` queue. `<id>` must be the ID of an item in the `<scope>` queue. Get ID from the output of `job-queue push`.

### `push`

```shell
job-queue push <scope> [<job_description> [<support_ticket_url>]]
```

Enqueue a job in the `<scope>` queue, and do not proceed until it is first in the queue. Outputs a timestamped random id.

You can have as many distinctly-named queues as you like.

The next time a job is pushed to the same scoped queue as the timed out job, a warning message will be logged to the terminal. If provided, `<job_description>` and `<support_ticket_url>` are included in the message.

### `version`

```shell
job-queue (--version | -v)
```

Show the current version.
