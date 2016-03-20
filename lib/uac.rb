require 'ffi'
require 'optparse'

module Uac
  class UacPrivate
    def encode_arg arg
      s = arg.gsub /(\\+)"/, "#{$1}#{$1}\""
      s = s.gsub /(\\+)$"/, "#{$1}#{$1}"
      if s.match /\s/
        s = "\"" + s + "\""
      end
      return s
    end

    def get_long_arg args
      return args.map do |arg|
        encode_arg arg
      end.join " "
    end

    def join_long_args args, separator = " "
      result = []
      for arg in args
        m = arg.match /^"(.+?)"$/
        if m
          core = m.captures[0]
        else
          core = arg
        end
        result << core
      end
      return result.join separator
    end

    def join_args options, args
      if options[:terminal]
        file = "cmd"
        rest_args = args
      else
        file = args[0]
        rest_args = args[1..-1]
      end

      rest = get_long_arg rest_args

      if options[:cd]
        pre = get_long_arg [ 'cd', '/d', Dir.pwd, '&' ]
        rest = join_long_args [ pre, rest ]
      end

      if options[:pause]
        post = get_long_arg([ '&', 'pause' ])
        rest = join_long_args [ rest, post ]
      end

      if options[:terminal]
        rest = "/c \"#{rest}\""
      end

      if options[:debug]
        puts "file: #{file}"
        puts "rest: #{rest}"
      end

      return [file, rest]
    end
  end

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

  def self.shell_execute options, args
    uac_private = UacPrivate.new

    (file, rest) = uac_private.join_args options, args

    verb = options[:verb] || "runas"

    Shell32.ShellExecuteA(
      nil,
      FFI::MemoryPointer.from_string(verb),
      FFI::MemoryPointer.from_string(file),
      FFI::MemoryPointer.from_string(rest),
      FFI::MemoryPointer.from_string(Dir.pwd),
      Shell32::SW_SHOWNORMAL)
  end
end
