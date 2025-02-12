# Usage

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

`job-queue push` has two optional parameters: `job-queue push <scope> <description> <new support ticket url>`. If a job times out, a message is logged to the terminal with information which may help in debugging.

Run `job-queue help` for documentation; if the package is installed with Homebrew, `man job-queue` is also available.







