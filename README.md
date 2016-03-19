This program elevates program privilege under a UAC enabled Windows environment.

# Installation

`gem install uac`

# Examples

* View netstat and then pause after execution

  ```batch
  uac netstat -anb
  ```

  It's equivalent to

  ```batch
  uac --no-terminal "netsatat -anb & pause"
  ```

* Another complex example

  This example changes directory to the current directory and then prints the directory structure. Without the `cd`, the newly opened terminal will start at `C:\WINDOWS\system32`.

  ```batch
  uac "cd /d %cd% && dir"
  ```

  Because Windows shell intercepts the special operators like `&`, `&&`, `>`, `|`.  It's necessary to quote the entire command. Otherwise uac won't see the `&& dir` part.

**Note**, by the nature of Windows design, a process cannot be elevated directly, only a new process can be granted the admin privilege. So uac opens a new window every time you call.
