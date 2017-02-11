
# ffurls

Saves tabs opened in Firefox to a file in some format.

---

### Requirements

This program has tested in Linux Fedora 20 and Mozilla Firefox 38.0.5.

### Building

Build the docs and read the README file in _build/ffurls_.

To build run:

```sh
$ ./configure
$ make
```

### Installation

To install run:

```sh
$ sudo make install
```

To uninstall run:

```sh
$ sudo make uninstall
```

---

Note:
Don't take files from this project before their building because they
are just templates for the ending program and its documentation. These
files may not work because template strings may brake the code as they
may be placed in the middle of code, not only in comments.
