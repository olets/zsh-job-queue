# What's new?

Highlights in 2.x

- <Badge type="warning">Since 2.0.0</Badge> `mktemp`-like workflow

  ```shell
  id=$(job-queue generate-id) # [!code --]
  job-queue push my-scope $id # [!code --]
  id=$(job-queue push my-scope) # [!code ++]
  job-queue pop $id
  ```
