# Installation

## Package

### Homebrew

zsh-job-queue is available on Homebrew. Run

```shell:no-line-numbers
brew install olets/tap/zsh-job-queue
```

and follow the post-install instructions logged to the terminal.

:::tip
`brew upgrade` will upgrade you to the latest version, even if it's a major version change.

Want to stay on this major version until you _choose_ to upgrade to the next? When installing zsh-job-queue with Homebrew for the first time, run

```shell
brew install olets/tap/zsh-job-queue@2
```

If you've already installed `olets/tap/zsh-job-queue` with Homebrew, you can switch to the v2 formula by running

```shell
brew uninstall --force zsh-job-queue && brew install olets/tap/zsh-job-queue@2
```

or to switch from v1 to v2, run

```shell
brew uninstall --force zsh-job-queue@1 && brew install olets/tap/zsh-job-queue@2
```

:::

### Others

zsh-job-queue may be available from package managers. If you know of one, please make a pull request to update this page!

## Plugin

You can install zsh-job-queue with a zsh plugin manager, including those built into frameworks such as Oh-My-Zsh (OMZ) and prezto. Each has their own way of doing things. Read your package manager's documentation or the [zsh plugin manager plugin installation procedures gist](https://gist.github.com/olets/06009589d7887617e061481e22cf5a4a).

:::tip
Want to stay on this major version until you _choose_ to upgrade to the next? Use your package manager's convention for specifying the branch `v2`.
:::

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
  Replace `<branch>` with a branch name. Good options are `main` (for the latest stable release), `next` (for the latest release, even if it isn't stable), or `v2` (for releases in this major version).

Then add `source path/to/zsh-job-queue.zsh` to your `.zshrc` (replace `path/to/` with the real path), and restart zsh:

```shell:no-line-numbers
exec zsh
```
