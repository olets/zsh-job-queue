# Installation

## Package

### Homebrew

zsh-job-queue is available on Homebrew. Run

```shell:no-line-numbers
brew install olets/tap/zsh-job-queue
```

and follow the post-install instructions logged to the terminal.

### Others

zsh-job-queue may be available from package managers. If you know of one, please make a pull request to update this page!

## Plugin

You can install zsh-job-queue with a zsh plugin manager, including those built into frameworks such as Oh-My-Zsh (OMZ) and prezto. Each has their own way of doing things. Read your package manager's documentation or the [zsh plugin manager plugin installation procedures gist](https://gist.github.com/olets/06009589d7887617e061481e22cf5a4a).

After adding the plugin to the manager, it will be available in all new terminals. To use it in an already-open terminal, restart zsh in that terminal:

```shell:no-line-numbers
exec zsh
```

## Manual

- Either download the latest release's archive from <https://github.com/olets/zsh-job-queue/releases> and expand it (ensures you have the latest official release)
- or clone a single branch:
  ```shell:no-line-numbers
  git clone https://github.com/olets/zsh-job-queue --single-branch --branch <branch> --depth 1
  ```
  Replace `<branch>` with a branch name. Good options are `main` (for the latest stable release), `next` (for the latest release, even if it isn't stable).

Then add `source path/to/zsh-job-queue.zsh` to your `.zshrc` (replace `path/to/` with the real path), and restart zsh:

```shell:no-line-numbers
exec zsh
```
