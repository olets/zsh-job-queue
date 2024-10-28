# zsh-job-queue ![GitHub release (latest by date)](https://img.shields.io/github/v/release/olets/zsh-job-queue)

**zsh-job-queue** manages a global synchronous job queue.

Run `job-queue help` for documentation; if the package is installed with Homebrew, `man job-queue` is also available.

## Installation

### Package

#### Homebrew

zsh-job-queue is available on Homebrew. Run

```shell:no-line-numbers
brew install olets/tap/zsh-job-queue
```

and follow the post-install instructions logged to the terminal.

#### Others

There may be others out there. If you know of one, please make a pull request to this page!

### Plugin

You can install zsh-abbr with a zsh plugin manager, including those built into frameworks such as Oh-My-Zsh (OMZ) and prezto. Each has their own way of doing things. Read your package manager's documentation or the [zsh plugin manager plugin installation procedures gist](https://gist.github.com/olets/06009589d7887617e061481e22cf5a4a).

After adding the plugin to the manager, it will be available in all new terminals. To use it in an already-open terminal, restart zsh in that terminal:

```shell:no-line-numbers
exec zsh
```

### Manual

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

## Usage

1. Get an id: `job-queue generate-id`.
2. Start a job with that id: `job-queue push <scope> <generated id>`.
3. Do some work.
4. End the job you started: `job-queue pop <scope> <generated id>`.

`job-queue push` has two optional parameters: `job-queue push <scope> <generated id> <description> <new support ticket url>`

## Example

You have a script that modifies a file. You want to support running the script in multiple terminals, in quick succession. You want to make sure that none of the runs' changes are lost.

Don't

```shell
myfunction() {
  echo $1 >> ~/myfile.txt # runs immediately
}
```

Do

```shell
myfunction() {
  local id=$(job-queue generate-id)
  job-queue push myfunction $id
  echo $1 >> ~/myfile.txt # waits its turn in the global 'myfunction' queue
  job-queue pop myfunction $id
}
```

## History

Forked from [zsh-abbr v5](https://v5.zsh-abbr.olets.dev/).

## Changelog

See the [CHANGELOG](CHANGELOG.md) file.

## Roadmap

See the [ROADMAP](ROADMAP.md) file.

## Contributing

_Looking for the documentation site's source? See <https://github.com/olets/zsh-job-queue-docs>_

Thanks for your interest. Contributions are welcome!

> Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

Check the [Issues](https://github.com/olets/zsh-job-queue/issues) to see if your topic has been discussed before or if it is being worked on. You may also want to check the roadmap (see above).

Please read [CONTRIBUTING.md](CONTRIBUTING.md) before opening a pull request.

## License

<a href="https://github.com/olets/zsh-job-queue">zsh-job-queue</a> by <a href="https://olets.dev">Henry Bley-Vroman</a> is licensed under a license which is the unmodified text of <a href="https://creativecommons.org/licenses/by-nc-sa/4.0">CC BY-NC-SA 4.0</a> and the unmodified text of a <a href="https://firstdonoharm.dev/build?modules=eco,extr,media,mil,sv,usta">Hippocratic License 3</a>. It is not affiliated with Creative Commons or the Organization for Ethical Source.

Human-readable summary of (and not a substitute for) the [LICENSE](LICENSE) file:

You are free to

- Share — copy and redistribute the material in any medium or format
- Adapt — remix, transform, and build upon the material

Under the following terms

- Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
- Non-commercial — You may not use the material for commercial purposes.
- Ethics - You must abide by the ethical standards specified in the Hippocratic License 3 with Ecocide, Extractive Industries, US Tariff Act, Mass Surveillance, Military Activities, and Media modules.
- Preserve terms — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.
- No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

## Acknowledgments

- The human-readable license summary is based on https://creativecommons.org/licenses/by-nc-sa/4.0. The ethics point was added.
