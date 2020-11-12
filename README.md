# reveries — a simple GnuPG-encrypted personal journal

```
    _ /_              .            *
     /     ___  _____   _________  ____________
          / _ \/ __/ | / / __/ _ \/  _/ __/ __/       .
 +       / , _/ _/ | |/ / _// , _// // _/_\ \  
        /_/|_/___/ |___/___/_/|_/___/___/___/
                                        +      _ /_
               *                                /
```

`reveries` is a Bash utility for managing GnuPG-encrypted journal entries. It provides a simple, trustless and future-proof way of storing your private thoughts, ideas, memories, etc. It was inspired by [`pass`](https://www.passwordstore.org/).

## How it works

Entries are GnuPG-encrypted text files stored in the `~/.reveries` directory. Each file is timestamped with [ISO-8601](https://en.wikipedia.org/wiki/ISO_8601)-formatted dates. Encryption and decryption happens on the fly where possible, otherwise the script makes use of [tmpfs](https://en.wikipedia.org/wiki/Tmpfs) to prevent temporary files from ever touching persistent storage. On systems where tmpfs is not available (notably macOS), the files will be [`shred`](https://en.wikipedia.org/wiki/Shred_(Unix))ded before deletion. A number of useful subcommands is provided for common tasks such as listing, viewing, editing, grepping, etc., combined with powerful selectors and filters.

## Dependencies

* [gpg2](https://gnupg.org/)

## Installation

**Note:** `reveries` is still in early stages — things may break. Backing up your entries is always a good idea.

```
$ git clone github.com/climech/reveries
$ cd reveries/
$ sudo make install
```

## Usage

### Selectors

Most of the commands expect a selector. Entries can be selected using index selectors, date selectors and ranges.

#### Index selectors

Index selectors select entries based on their current position on the list, with 1 being the oldest. Negative indices can be used to count from the end of the list. For example, to list the latest entry:

```
$ reveries ls -1

Tue 14 Jul 2020 07:43:27 PM CEST (42)
```

Multiple selectors may be used:

```
$ reveries ls 1 4 -1

Tue 31 Dec 2019 03:12:22 PM CEST (1)
Fri 3 Jan 2020 09:13:49 PM CEST (4)
Tue 14 Jul 2020 07:43:27 PM CEST (42)
```

#### Date selectors

A date selector is a string following the format `YYYY-MM-DD`. It selects all entries created on the given date.

```
$ reveries ls 2019-12-31

Tue 31 Dec 2019 03:12:22 PM CEST (1)
Tue 31 Dec 2019 03:44:01 PM CEST (2)
```

#### Ranges

Multiple entries may be selected by providing a range:

```
$ reveries ls 1:4

Tue 31 Dec 2019 03:12:22 PM CEST (1)
Tue 31 Dec 2019 03:44:01 PM CEST (2)
Thu 2 Jan 2020 02:02:58 PM CEST (3)
Fri 3 Jan 2020 09:13:49 PM CEST (4)

$ reveries ls 2020-01-01:2020-02-01

Thu 2 Jan 2020 02:02:58 PM CEST (3)
Fri 3 Jan 2020 09:13:49 PM CEST (4)
...
```

All ranges are inclusive. Either boundary may be omitted, creating an unbounded range in that direction. Omitting both parts (`:`) selects all entries.

### Filters

(TODO)

### Commands

#### init \<gpg-id\>

Initializes the program by setting the GPG key. Existing entries are re-encrypted using the new key.

```
$ reveries init "John Doe"
```

#### new

Opens the `$EDITOR`. A new entry is created on exit, if the file was saved. `new` runs implicitly when no command is given.

#### list|ls [\<selector\>...]

Prints out a list of selected entries. It selects all entries when no
selector is given.

```
$ reveries ls

Tue 31 Dec 2019 08:12:22 PM CEST (1)
Tue 31 Dec 2019 03:44:01 PM CEST (2)
...
```

#### cat \<selector\>...

Decrypts selected entries and print them out.

#### view \<selector\>...

Decrypts the selected entries, concatenates and pipes them into `less`. The entries are word-wrapped to fit the current terminal width (capped at 80 characters). Each entry begins with a header showing the creation time.

```
$ reveries view 2
```

#### edit \<index\>

Opens the `$EDITOR` to edit the selected file. The entry is updated on exit, if the file was saved.

#### grep \<grep-args\> [\<selector\>...]

Decrypts the selected entries and pipes them into `grep`. If no selector is given, all entries are searched.

```
$ reveries grep -i dolor 1

Tue 31 Dec 2019 03:12:22 PM CEST (1):
Lorem ipsum [dolor] sit amet, consectetur adipiscing elit. Proin et ligula orci.
ante elementum [dolor], quis faucibus tortor risus vel sem. Aliquam varius
```

#### remove|rm \<selector\>...

Deletes the selected entries. Prompts for confirmation when attempting to delete multiple entries.

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

-------

© climech.org
