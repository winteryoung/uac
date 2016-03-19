app_name = "uac"

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
  rm_rf FileList["*.gem"]
end

gem_source_files = FileList.new "lib/*", "bin/*", "#{app_name}.gemspec"
gem_files = FileList.new "*.gem"

rule '.gem' => gem_source_files do
  sh "gem build #{app_name}.gemspec"
end

task :build => gem_files

task :publish => [ :clean, :build ] do
  FileList["*.gem"].each do |f|
    sh "gem push #{f}"
  end
end
