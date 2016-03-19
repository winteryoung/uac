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

* Another complex example

  This example change directory to the current directory and then print the directory structure.

  ```batch
  uac -p -- "cd /d %cd% && dir"
  ```
