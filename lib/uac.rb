require 'ffi'
require 'optparse'

def split_args
  i = ARGV.index '--'
  if i
    return [ ARGV[0...i], ARGV[(i+1)..-1] ]
  else
    return [ [], ARGV ]
  end
end

(meta_args, args) = split_args

options = {}
OptionParser.new do |opt|
  opt.banner = <<-EOF
Usage: uac <OPTIONS> <COMMAND>

Options:

* --help, -h
  Print this help.

* --pause, -p
  Pause after execution. This implies executing command line,
  so cmd.exe is the program to be executed.

Argument separator:

'--' is used to separate the options passed to uac and the commands
to be executed. Example is shown below. If an option for uac is
present (example '-p'), then '--' is required.

Example:

* Echo hello
  uac cmd /k "echo hello"

* Pause after execution
  uac -p -- netstat -anb
  It's equivalent to
  uac cmd /k "netsatat -anb & pause"
EOF
  opt.on('--help', '-h') do |o|
    puts opt.banner
    exit
  end
  opt.on('--pause', '-p') do |o|
    options[:pause] = o
  end
end.parse! meta_args

module Shell32
  extend FFI::Library

  ffi_lib 'shell32'
  ffi_convention :stdcall

  # HINSTANCE ShellExecute(HWND hwnd, LPCTSTR lpOperation, LPCTSTR lpFile, LPCTSTR lpParameters, LPCTSTR lpDirectory, INT nShowCmd)
  attach_function :ShellExecuteA, [ :pointer, :pointer, :pointer, :pointer, :pointer, :int ], :pointer

  SW_HIDE = 0
  SW_SHOWNORMAL = 1
  SW_SHOWMINIMIZED = 2
  SW_SHOWMAXIMIZED = 3
  SW_SHOWNOACTIVATE = 4
  SW_SHOW = 5
  SW_MINIMIZE = 6
  SW_SHOWMINNOACTIVE = 7
  SW_SHOWNA = 8
  SW_RESTORE = 9
  SW_SHOWDEFAULT = 10
end

def encode_arg arg
  s = arg.gsub /(\\+)"/, "#{$1}#{$1}\""
  s = s.gsub /(\\+)$"/, "#{$1}#{$1}"
  if s.match /\s/
    s = "\"" + s + "\""
  end
  return s
end

def shell_execute options, args
  if options[:pause]
    file = "cmd"
    rest = args.map do |arg|
      encode_arg arg
    end.join " "
    rest = "/c \"#{rest} & pause\""
  else
    file = args[0]
    rest = args[1..-1].map do |arg|
      encode_arg arg
    end.join " "
  end

  puts file
  puts rest

  Shell32.ShellExecuteA(
    nil,
    FFI::MemoryPointer.from_string("runas"),
    FFI::MemoryPointer.from_string(file),
    FFI::MemoryPointer.from_string(rest),
    FFI::MemoryPointer.from_string(Dir.pwd),
    Shell32::SW_SHOWNORMAL)
end

shell_execute options, args
