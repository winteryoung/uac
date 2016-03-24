require 'rake/clean'

APP_NAME = "uac"
TARGET_DIR = "target"
EXE_DIRECTIVE = "# EXE_PACKAGE_DIRECTIVE"

require 'winter_rakeutils'
WinterRakeUtils.load_git_tasks
WinterRakeUtils.load_gem_tasks

task :local => [ :clobber, :local_gem ]

task :test do
  tests = FileList.new "test/**/*_test.rb"
  tests.each do |test|
    system "ruby #{test}"
  end
end

def merge_exe_src exe_src
  lines = []

  exe_src.each do |f|
    File.open f, "rb" do |file|
      met_directive = false
      file.read.lines.each do |line|
        if line.strip == EXE_DIRECTIVE
          met_directive = true
          lines << "\n"
          lines << "# #{f}\n"
        elsif met_directive
          lines << line
        end
      end
    end
  end

  return lines.join ""
end

rule /#{TARGET_DIR}\/.+?\.exe/ => [ proc {|name|
  m = name.match /#{TARGET_DIR}\/(.+?)\.exe/
  name = m.captures[0]
  "#{TARGET_DIR}/#{name}_exe.rb"
}, TARGET_DIR ] do |t|
  sh "ocra --output #{t.name} #{t.source}"
end

def define_exe_rb_task exe_name
  exe_src = FileList.new "lib/uac.rb", "lib/uac_sh.rb", "bin/#{exe_name}"
  file "#{TARGET_DIR}/#{exe_name}_exe.rb" => [*exe_src, TARGET_DIR] do |t|
    text = merge_exe_src exe_src
    File.open t.name, "wb" do |f|
      f.write text
    end
  end
end

define_exe_rb_task "uac"
define_exe_rb_task "uacs"

task :exe => [TARGET_DIR, *FileList.new("bin/*").pathmap("%{^bin/,#{TARGET_DIR}/}p.exe")]

task :publish => [ :clobber, :publish_gem, :exe ] do
  sh "gem push #{gem_file}"
end
