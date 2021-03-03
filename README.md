<p align="center">
  <img src="docs/assets/tfw.gif" height="200" />
</p>
<p align="center"><em>“Trust nobody, not even yourself”</em></p>
<p align="center"><em>—a wise man</em></p>

# tfw

`tfw` is a command-line tool that manages a collection of timestamped, `gpg`-encrypted journal entries. It provides a simple, trustless and future-proof way of storing your private thoughts, ideas, memories, etc.

The way it works was largely inspired by [`pass`](https://www.passwordstore.org/)—a simple password manager that adheres to the [Unix philosophy](https://en.wikipedia.org/wiki/Unix_philosophy).

## How it works

The entries are [`gpg`](https://gnupg.org/)-encrypted plain text files stored in `~/.config/tfw/entries`. Each file has a name that follows the [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601) date format. Encryption and decryption happens on the fly where possible, otherwise the script makes use of [tmpfs](https://en.wikipedia.org/wiki/Tmpfs) to prevent unencrypted secrets from ever touching persistent storage. On macOS, where tmpfs is not available, temporary files are [shredded](https://en.wikipedia.org/wiki/Shred_(Unix)) before deletion.

A number of useful subcommands is provided for common tasks such as listing, viewing, editing, grepping, etc., combined with powerful selectors and filters.

## Dependencies

The script depends on [GnuPG](https://gnupg.org/) for encryption.

## Installation

Get the latest release, change into the directory, and run:

```
$ make && sudo make install
```

The `make` command is used to insert the current version into the script; `make install` also installs Bash completion.

## Usage

### Selectors

Most of `tfw` commands expect a selector. Entries can be selected using index selectors, date selectors and index/date ranges.

#### Index selectors

Index selectors work on a list of entries ordered chronologically. Index `1` selects the oldest entry available. Negative indices may be used to count from the end of the list, e.g. to list the most recent entry:

```
$ tfw ls -1

Tue 14 Jul 2020 07:43:27 PM CEST (42)
```

Multiple selectors work too:

```
$ tfw ls 1 4 -1

Tue 31 Dec 2019 03:12:22 PM CEST (1)
Fri 3 Jan 2020 09:13:49 PM CEST (4)
Tue 14 Jul 2020 07:43:27 PM CEST (42)
```

#### Date selectors

A date selector is a string that follows the format `YYYY-MM-DD`. It selects all entries created on the specified date.

```
$ tfw ls 2019-12-31

Tue 31 Dec 2019 03:12:22 PM CEST (1)
Tue 31 Dec 2019 03:44:01 PM CEST (2)
```

#### Ranges

Multiple entries may be selected by specifying a range:

```
$ tfw ls 1:4

Tue 31 Dec 2019 03:12:22 PM CEST (1)
Tue 31 Dec 2019 03:44:01 PM CEST (2)
Thu 2 Jan 2020 02:02:58 PM CEST (3)
Fri 3 Jan 2020 09:13:49 PM CEST (4)

$ tfw ls 2020-01-01:2020-02-01

Thu 2 Jan 2020 02:02:58 PM CEST (3)
Fri 3 Jan 2020 09:13:49 PM CEST (4)
...
```

Either boundary may be omitted, creating an unbounded range in either direction. Omitting both parts (`:`) selects all entries.

### Filters

(TODO)

### Commands

#### init \<gpg-id\>

Initializes the program by setting the GPG key. Any existing entries are re-encrypted using the new key.

```
$ tfw init "John Doe"
```

#### new

Opens the `$EDITOR`. A new entry is created on save. The `new` command is invoked implicitly when no command is given.

#### list|ls [\<selector\>...]

Prints out a list of selected entries. If no selector is given, all entries are selected.

```
$ tfw ls

Tue 31 Dec 2019 08:12:22 PM CEST (1)
Tue 31 Dec 2019 03:44:01 PM CEST (2)
...
```

#### cat \<selector\>...

Decrypts and prints out selected entries.

#### view \<selector\>...

Decrypts the entries and pipes them into `less` for reading.

The entries are concatenated and wrapped to fit the current terminal width, capped at 80 characters. Each entry begins with a header showing the creation time.

#### edit \<index\>

Opens the `$EDITOR` to edit the selected file. The entry is updated on exit, if the file was saved.

#### grep \<grep-args\> [\<selector\>...]

Decrypts the selected entries and pipes them into `grep`. If no selector is given, all entries are searched.

```
$ tfw grep -i dolor 1

Tue 31 Dec 2019 03:12:22 PM CEST (1):
Lorem ipsum [dolor] sit amet, consectetur adipiscing elit. Proin et ligula orci.
ante elementum [dolor], quis faucibus tortor risus vel sem. Aliquam varius
```

#### remove|rm \<selector\>...

Deletes the selected entries. Prompts for confirmation when attempting to delete multiple entries.

**NOTE:** the indices are not IDs! If you remove an entry from the middle of the list, the next one will take its place. When in doubt, run `ls` again before removing any more entries.

#### help

Displays helpful information.

#### version

Displays program version.

## TODO

* Write a man page;
* Improve completion;
* Write completion for other shells besides Bash;
* Add filters (`year:2020`, `weekday:friday`, etc., applied to current selection);
* Add optional flags to some subcommands.

## License

This project is released under the [MIT license](https://en.wikipedia.org/wiki/MIT_License).
