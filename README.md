This program elevates program privilege under a UAC enabled Windows environment.

# Installation

`gem install uac`

# Examples

* Echo hello

```batch
uac cmd /k "echo hello"
```

* Pause after execution

```batch
uac -p -- netstat -anb
```

It's equivalent to

```batch
uac cmd /k "netsatat -anb & pause"
```
**Note**, by the nature of Windows design, a process cannot be elevated directly, only a new process can be granted the admin privlege. So uac opens a new window every time you call.
