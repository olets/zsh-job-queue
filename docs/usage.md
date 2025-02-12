# Usage

1. Claim an ordered place in the queue: `job-queue generate-id`.
2. Join the `<scope>`'s queue in that place, and pause to wait for the job's turn: `job-queue push <scope> <generated id>`.
3. Do some work.
4. End the job you started: `job-queue pop <scope> <generated id>`.

These should be done in immediate succession, like so:

```shell
id=$(job-queue generate-id)
job-queue push my-scope $id

# do work here

job-queue pop my-scope $id
```

::: danger Time constraint
If a started (`push`ed) job does not complete (`pop`) within `JOB_QUEUE_TIMEOUT_AGE_SECONDS` seconds (docs: [Options](/options) from its claiming a place in the queue (`generate-id`), it is considered to have timed out. I don't remember what led me to time based on when `generate-id` is run rather than when `push` is run, but that's how it is. Not going to break things now! If you don't delay between `generate-id` and `push`, it shouldn't make a difference.
:::

`job-queue push` has two optional parameters: `job-queue push <scope> <generated id> <description> <new support ticket url>`. If a job times out, a message is logged to the terminal with information which may help in debugging.

Run `job-queue help` for documentation; if the package is installed with Homebrew, `man job-queue` is also available.

## Try it out

1. Open two terminals.

1. In the first, type _but do not accept_

   ```shell
   id=$(job-queue generate-id); job-queue push testing $id; sleep 10; job-queue pop testing $id; echo first job done at $(date)
   ```

1. In the second, type _but do not accept_

   ```shell
   id=$(job-queue generate-id); job-queue push testing $id; job-queue pop testing $id; echo second job done at $(date)
   ```

1. Accept the first terminal's command, and immediately accept the second terminal's command. See that the second terminal's command is blocked (waits for) the first terminal's.
