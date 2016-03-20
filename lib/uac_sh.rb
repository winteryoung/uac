require_relative 'uac'

# EXE_PACKAGE_DIRECTIVE

module UacSh
  def self.split_args args
    i = args.index '--'
    if i
      return [ args[0...i], args[(i+1)..-1] ]
    else
      return [ [], args ]
    end
  end

  def self.parse_meta_args options, args
    option_parser = OptionParser.new do |opt|
      opt.banner = <<-EOF
  Usage: uac <OPTIONS> <COMMAND>

  For examples please see https://github.com/winteryoung/uac
  EOF

      opt.separator ""
      opt.separator "Options:"

      terminal_help = 'The given command will be executed in a terminal window, so cmd /c is added implictly. This is enabled by default.'
      opt.on('-t', '--[no-]terminal', terminal_help) do |o|
        options[:terminal] = o
        if not o
          options[:pause] = o
          options[:cd] = o
        end
      end

      pause_help = 'Pause after execution. This implies executing command line, so cmd.exe is the program to be executed. This option implies --terminal. This is enabled by default.'
      opt.on('-p', '--[no-]pause', pause_help) do |o|
        options[:pause] = o
        if o
          options[:terminal] = o
        end
      end

      opt.on('--debug') do |o|
        options[:debug] = o
      end

      opt.on('--cd', '-c', 'Change to current directory. Default is true. This option implies --terminal.') do |o|
        options[:cd] = o
        if o
          options[:terminal] = o
        end
      end

      opt.on_tail('-h', '--help', 'Print this help.') do |o|
        puts opt
        exit
      end
    end.parse! args
  end

  def self.run options, args
    (meta_args, args) = split_args args

    all_options = args.all? do |arg|
      arg.start_with? "-"
    end
    if all_options
      meta_args = args
      args = []
    end

    options = {
      :pause => true,
      :terminal => true,
      :cd => true
    }.merge options

    parse_meta_args options, meta_args

    if options[:debug]
      puts "options: #{options}"
      puts "args: #{args}"
    end

    if not args or args.empty?
      exit
    end

    Uac.shell_execute options, args
  end
end
