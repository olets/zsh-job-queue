# Migrating between versions

## Migrating from v2

- The `mktemp`-like workflow has been dropped in favor of a `REPLY`-based on. Replace all instances of

  ```shell
  id=$(job-queue push my-scope)
  job-queue pop $id
  ```

  with

  ```shell
  job-queue push my-scope
  id=$REPLY
  job-queue pop $id
  ```
