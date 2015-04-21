# Zonemaster Web GUI Installation

Since it is a web application, the Zonemaster Web GUI is a bit more complicated to install than, for example, the test engine. The exact details also depend on the operating system and environment in which it is installed, so it's not really possible to provide general point-by-point instructions.

Basically, the GUI has two major parts. One part is the Perl modules that hold most of the application logic, and the other part is the HTML template files, CSS files, Javascript files and so on that the application logic needs. The Perl module part can be installed as any other Perl module, and is not at all problematic. For the second part, there is no widely accepted place or way to install it, and different operating systems want it in different places. For this reason, we have put all that stuff in a subdirectory of its own in the source code, so you can easily copy it to wherever suits your environment best.

So, in essence, the installation consists of the following steps:

1) Fetch the source code to the Web GUI.

2) Install all the various prerequisite software. This includes the Zonemaster Web Backend, which in turn requires the Zonemaster test engine. The backend also needs access to a database server.

3) Install the Perl module part of the GUI using the usual `perl Makefile.PL && make && make test && make install` sequence.

4) Copy the entire subdirectory `zm_app` from the source code to somewhere suitable. This may be, for example, `/usr/local/webapps/` or `/usr/share/doc/`.

5) Start the server. How to do this can also vary a lot, depending on what else is running on the same server, how much traffic you're expecting to get and such. In any case, you need a server that understands the `PSGI` interface, and it should be pointed at the file `zm_app/bin/app.pl` in the subdirectory you just copied things to (leaving it in the source code also works, of course).

## Example installation for Unbuntu Server 14.04LTS

