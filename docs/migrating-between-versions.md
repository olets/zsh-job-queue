# Migrating between versions

## Migrating from v1

- The `generate-id` subcommand has been dropped in favor of a `mktemp`-like workflow. Replace all instances of

  ```shell
  id=$(job-queue generate-id)
  job-queue push my-scope $id
  job-queue pop $id
  ```

  with

  ```shell
  id=$(job-queue push my-scope)
  job-queue pop $id
  ```
