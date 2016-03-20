require 'rake'

Gem::Specification.new do |s|
  s.name        = 'uac'
  s.version     = '0.3.0'
  s.date        = '2016-03-19'
  s.summary     = "Windows UAC elevator"
  s.description = "Executes commands with elevated privilege in Windows"
  s.authors     = [ "Winter Young" ]
  s.email       = '513805252@qq.com'
  s.files       = FileList.new "lib/*.rb"
  s.homepage    = 'https://github.com/winteryoung/uac'
  s.license     = 'Apache-2.0'
  s.executables = [ "uac", "uacs" ]
end
