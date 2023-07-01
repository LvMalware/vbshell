# VBShell

> A simple C2 written with VBScript agents

This is a toy C2 program with VBScript agents that run natively (i.e no additional installation is necessary) on windows and communicate via HTTP(S) to a Perl-based controller.

## Installation

1. Clone the repository and install the server dependencies (linux-only)

```bash
git clone https://github.com/lvmalware/vbshell
cd vbshell
cpanm --installdeps .
```

2. Run the server using [Morbo](https://mojolicious.org/)

```bash
morbo -l http://*:3000 -m production server.pl #you might want to change the port 3000 to something else
```

3. Edit the vbshell.vbs file and change the value of CALLBACKURL to your C2 server's url

```vbscript
CALLBACKURL = "http://my.server.tld"
```
4. Obfuscate the script somehow (optional)

5. Copy the vbshell.vbs file to your target and run it

6. Have fun
