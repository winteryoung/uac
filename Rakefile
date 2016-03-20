require "rubygems"

app_name = "uac"

gem_spec = Gem::Specification::load("#{app_name}.gemspec")
ver = gem_spec.version

def working_dir_clean?
  `git status`.lines.each do |line|
    if line.index "Changes to be committed"
      return false
    end
  end
  return true
end

task :gitcommit do
  sh "git add -A"
  if not working_dir_clean?
    sh "git commit -m auto"
    sh "git push"
  end
end

task :clean do
  rm_rf "target"
end

gem_source_files = FileList.new "lib/*", "bin/*", "#{app_name}.gemspec"
gem_file = FileList.new "target/#{app_name}-#{ver}.gem"

rule /target\/.+?\.gem/ => gem_source_files do |t|
  mkdir_p "target"
  sh "gem build #{app_name}.gemspec"
  mv "#{app_name}-#{ver}.gem", "target"
end

task :build => "target/#{app_name}-#{ver}.gem"

task :publish => [ :clean, :build ] do
  sh "gem push #{gem_file}"
end

task :local => [ :clean, :build ] do
  sh "gem uninstall #{app_name}"
  pwd = Dir.pwd
  Dir.chdir "target"
  sh "gem install #{app_name}-#{ver}.gem"
  Dir.chdir pwd
end

task :test do
  tests = FileList.new "test/**/*_test.rb"
  tests.each do |test|
    system "ruby #{test}"
  end
end

DIRECTIVE = "# EXE_PACKAGE_DIRECTIVE"

def merge_exe_src exe_src
  lines = []

  exe_src.each do |f|
    File.open f, "rb" do |file|
      met_directive = false
      file.read.lines.each do |line|
        if line.strip == DIRECTIVE
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

rule /target\/.+?\.exe/ => proc {|name|
  m = name.match /target\/(.+?)\.exe/
  name = m.captures[0]
  "target/#{name}_exe.rb"
} do |t|
  mkdir_p "target"
  sh "ocra --output #{t.name} #{t.source}"
end

def define_exe_task exe_name
  exe_src = FileList.new "lib/*", "bin/#{exe_name}"
  file "target/#{exe_name}_exe.rb" => exe_src do |t|
    mkdir_p "target"
    text = merge_exe_src exe_src
    File.open t.name, "wb" do |f|
      f.write text
    end
  end
end
define_exe_task "uac"
define_exe_task "uacs"

task :exe => [ "target/uac.exe", "target/uacs.exe" ]
