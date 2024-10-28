# zsh-job-queue ![GitHub release (latest by date)](https://img.shields.io/github/v/release/olets/zsh-job-queue)

**zsh-job-queue** manages a global synchronous job queue.

Run `job-queue help` for documentation; if the package is installed with Homebrew, `man job-queue` is also available.

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
