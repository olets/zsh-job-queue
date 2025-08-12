# What's new?

Highlights in 3.x

- <Badge type="warning">Since 3.0.0</Badge> `REPLY`-based `push` workflow

  ```shell
  id=$(job-queue push my-scope) # [!code --]
  job-queue push my-scope # [!code ++]
  id=$REPLY # [!code ++]
  job-queue pop $id
  ```
