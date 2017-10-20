# Installation

## Overview

This document describes an abstract, prerequisites, installation and
post-install sanity checking for Zonemaster::GUI. The final section wraps up
with a few pointer to other interfaces to Zonemaster. For an overview of the
Zonemaster product, please see the [main Zonemaster Repository].


## Abstract

Since it is a web application, the Zonemaster Web GUI is a bit more complicated
to install than, for example, the test engine. The exact details also depend on
the operating system and environment in which it is installed, so it's not
really possible to provide general point-by-point instructions.

Basically, the GUI has two major parts. One part is the Perl modules that hold
most of the application logic, and the other part is the HTML template files,
CSS files, Javascript files and so on that the application logic needs. The Perl
module part can be installed as any other Perl module, and is not at all
problematic. For the second part, there is no widely accepted place or way to
install it, and different operating systems want it in different places. For
this reason, we have put all that stuff in a subdirectory of its own in the
source code, so you can easily copy it to wherever suits your environment best.

So, in essence, the installation consists of the following steps:

1) Fetch the source code to the Web GUI.

2) Install all the various prerequisite software. This includes the Zonemaster
   Web Backend, which in turn requires the Zonemaster test engine. The backend
   also needs access to a database server.

3) Install the Perl module part of the GUI using the usual `perl Makefile.PL &&
   make && make test && make install` sequence.

4) Copy the entire subdirectory `zm_app` from the source code to somewhere
   suitable. This may be, for example, `/usr/local/webapps/` or
   `/usr/share/doc/`.

5) Start the server. How to do this can also vary a lot, depending on what else
   is running on the same server, how much traffic you're expecting to get and
   such. In any case, you need a server that understands the `PSGI` interface,
   and it should be pointed at the file `zm_app/bin/app.pl` in the subdirectory
   you just copied things to (leaving it in the source code also works, of
   course).


## Prerequisites

Before installing Zonemaster::GUI, you should [install Zonemaster::Engine][
Zonemaster::Engine installation] and [Zonemaster::Backend][Zonemaster::Backend
installation].

> **Note:** [Zonemaster::Backend], and consequently [Zonemaster::Engine] and
> [Zonemaster::LDNS] are dependencies of Zonemaster::GUI. Zonemaster::LDNS has a
> special installation requirement, and both Zonemaster::Engine and
> Zonemaster::Backend have lists of dependencies that you may prefer to
> install from your operating system distribution (rather than CPAN).
> We recommend following the Zonemaster::Engine and Zonemaster::Backend
> installation instruction.

For details on supported versions of Perl and operating system for
Zonemaster::CLI, see the [declaration of prerequisites].


## Installation

This instruction covers the following operating systems:

 1. [CentOS](#1-centos)
 2. [Debian](#2-debian)
 3. [Docker](#3-docker)
 4. [FreeBSD](#4-freebsd)
 5. [Ubuntu](#5-ubuntu)


### 1. CentOS

1) Install additional prerequisite packages.

    sudo cpan -i Dancer Text::Markdown Template JSON

2) Get the source code.

    git clone https://github.com/dotse/zonemaster-gui.git

3) Change to the source code directory.

    cd zonemaster-gui

4) Install the Perl modules.

    perl Makefile.PL
    make
    make test
    make install

5) Create a directory for the webapp parts, and copy them there.

    mkdir -p /usr/local/share/zonemaster
    cp -a zm_app /usr/local/share/zonemaster

6) Start the server:

    starman --listen=:80 --daemonize /usr/local/share/zonemaster/zm_app/bin/app.pl


### 2. Debian

1) Install added prerequisite packages:

    sudo apt-get install libdancer-perl libtext-markdown-perl libtemplate-perl libjson-any-perl

2) Get the source code.

    git clone https://github.com/dotse/zonemaster-gui.git

3) Change to the source code directory.

    cd zonemaster-gui

4) Install the Perl modules.

    perl Makefile.PL
    make
    make test
    sudo make install

5) Create a directory for the webapp parts, and copy them there.

    sudo mkdir -p /usr/share/doc/zonemaster
    sudo cp -a zm_app /usr/share/doc/zonemaster

6) Start the server:

    sudo starman --listen=:80 /usr/share/doc/zonemaster/zm_app/bin/app.pl

The Doc directory in the source code also has an example Upstart file for the Web GUI starman server.


### 3. Docker

Install the docker package on your OS

Follow the installation instructions for your OS -> https://docs.docker.com/engine/installation/linux/
	
Pull the docker image containing the complete Zonemaster distribution (GUI + Backend + Engine)

	docker pull afniclabs/zonemaster-gui

Start the container in the background

	docker run -t -p 50080:50080 afniclabs/zonemaster-gui
	
Use the Zonemaster GUI by pointing your browser at

	http://localhost:50080/
	
Use the Zonemaster engine from the command line

	docker run -t -i afniclabs/zonemaster-gui bash
	

### 4. FreeBSD

Become root:

    su -

2) Install additional prerequisite packages.

    pkg install p5-Dancer p5-Text-Markdown p5-Template-Toolkit

3) Get the source code.

    git clone https://github.com/dotse/zonemaster-gui.git

4) Change to the source code directory.

    cd zonemaster-gui

5) Install the Perl modules.

    perl Makefile.PL
    make
    make test
    make install

6) Create a directory for the webapp parts, and copy them there.

    mkdir -p /usr/local/share/zonemaster
    cp -a zm_app /usr/local/share/zonemaster

7) Start the server:

    starman --listen=:80 --daemonize /usr/local/share/zonemaster/zm_app/bin/app.pl


### 5. Ubuntu

Use the procedure for installation on [Debian](#2-debian).


## Post-installation sanity check

Point your browser at `http://localhost/` (or the address of the server where
you installed Zonemaster::GUI).

> **Note:** For the Docker installation, the URL is `http://localhost:50080/`.

Verify that the Zonemaster GUI is shown with the "Zonemaster Test Engine
Version" in its page footer.


## What to do next?

 * For a JSON-RPC API, see the Zonemaster::Backend [JSON-RPC API] documentation.
 * For a command line interface, follow the [Zonemaster::CLI installation] instruction.
 * For a Perl API, see the [Zonemaster::Engine API] documentation.

-------

[Declaration of prerequisites]: https://github.com/dotse/zonemaster/blob/master/README.md#prerequisites
[JSON-RPC API]: https://github.com/dotse/zonemaster-backend/blob/master/docs/API.md
[Main Zonemaster repository]: https://github.com/dotse/zonemaster/blob/master/README.md
[Zonemaster::Backend installation]: https://github.com/dotse/zonemaster-backend/blob/master/docs/Installation.md
[Zonemaster::Backend]: https://github.com/dotse/zonemaster-backend/blob/master/README.md
[Zonemaster::CLI installation]: https://github.com/dotse/zonemaster-cli/blob/master/docs/Installation.md
[Zonemaster::Engine API]: http://search.cpan.org/%7Eznmstr/Zonemaster-Engine/lib/Zonemaster/Engine/Overview.pod
[Zonemaster::Engine installation]: https://github.com/dotse/zonemaster-engine/blob/master/docs/Installation.md
[Zonemaster::Engine]: https://github.com/dotse/zonemaster-engine/blob/master/README.md
[Zonemaster::LDNS]: https://github.com/dotse/zonemaster-ldns/blob/master/README.md

Copyright (c) 2013 - 2017, IIS (The Internet Foundation in Sweden) \
Copyright (c) 2013 - 2017, AFNIC \
Creative Commons Attribution 4.0 International License

You should have received a copy of the license along with this
work.  If not, see <http://creativecommons.org/licenses/by/4.0/>.
