
# ffurls

Saves tabs opened in Firefox to a file in some format.

---

### Requirements


This program has tested on environment configuration
```
1)
  Linux Fedora 20
  Python 3.3.2
  Mozilla Firefox 38.0.5
  GNU bash 4.4.12
2)
  Linux Fedora 26
  Python 3.6.5 with package lz 2.1.0
  Mozilla Firefox 60.0.0
  GNU bash 4.4.12
```

### Building

Build the docs and read the README file in _build/docs_.

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

### Set program config

You can use general system config or set your own config to override
fields:

```sh
$ vi ~/.ffurls.conf
```

### Run

```sh
$ ffurls.sh
```

---
