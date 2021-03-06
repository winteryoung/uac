This program elevates program privilege under a UAC enabled Windows environment, just like `sudo` in Linux.

# Installation

* If you have Ruby installed

  `gem install uac`

  This version runs fast. Because it doesn't have Ruby runtime embedded.

* If you don't have Ruby installed

  Download from https://github.com/winteryoung/uac/releases

# Examples

* View netstat and then pause after execution.

  ```batch
  uac netstat -anb
  ```

* Executing multiple commands (including shell directives) and pause after execution.

  ```batch
  uac "cd /d d:\ && dir"
  ```

  Because Windows shell intercepts the special operators like `&`, `&&`, `>`, `|`.  It's necessary to quote the entire command. Otherwise uac won't see the `&& dir` part.

* Starting a service or windows application with admin privilege, but do not open a terminal.

  ```batch
  uacs putty yoursite.com
  ```

  It's equivalent to

  ```batch
  uac --no-terminal -- putty yoursite.com
  ```

  `uacs` is the shorthand for

  ```batch
  uac --no-terminal -- <COMMAND>
  ```

  `--no-terminal` option here is to not start a terminal window when executing the given command. `--` is used to separate the options passed to uac and the commands to be executed.

* Starting a terminal with admin privilege.

  ```batch
  uacs cmd
  ```

# Getting Help

```batch
uac -h
```

**Note**, by the nature of Windows design, a process cannot be elevated directly, only a new process can be granted the admin privilege. So uac opens a new window or starts a new process every time you call.
