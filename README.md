Only tested on Ubuntu and Kali, may not work for non-debian distros.

# Ubuntu DFIR VM Guide

## Directory Structure

All tools are organized under:


`/opt/dfir`


### `/opt/dfir/git`
- Git-cloned repositories
- Source-managed tools
- Manually maintained

### `/opt/dfir/windows`
- Contains Windows forensic executables
- PowerShell (`pwsh`) is installed system-wide
- All Eric Zimmerman tools are stored here
- `.exe` files are auto-wrapped into lowercase commands in `/usr/local/bin`
- Tools can be run globally by typing their lowercase name

Example:

`/opt/dfir/windows/JLECmd.exe`


Run from anywhere:

`jlecmd`


### `/opt/dfir/custom`
- Manually compiled or specialty tools

---

## Updating Tools

### Update System Packages

`sudo apt update && sudo apt upgrade -y`


### Update Python Tools (pipx)

`pipx upgrade-all`


### Update Eric Zimmerman Tools

`pwsh Get-ZimmermanTools.ps1` located in `/opt/dfir/windows`


If new `.exe` files are added, re-run the wrapper script.

---

## Adding New Tools

### Add a Python Tool

`pipx install git+<github link>`


### Add a Windows Executable
1. Place the `.exe` file in:

`/opt/dfir/windows`

2. Re-run the wrapper script.
3. Invoke it globally using its lowercase name.

---

## Execution Model

| Tool Type        | Managed By | Invocation |
|------------------|------------|------------|
| Native Linux     | apt        | Direct     |
| Python CLI       | pipx       | Direct     |
| Windows (.exe)   | Wine + wrapper | Lowercase name |

---

## Best Practices

- Use `pipx` for Python tools
- Keep Windows tools only in `/opt/dfir/windows`
- Upgrade regularly
- Do not modify system permissions unnecessarily
