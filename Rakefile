require 'rubygems'
require 'rake/rdoctask'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.summary = "gem plugin that synchronizes gem bindir with /usr/local/bin"
  s.name = "pathfixer"
  s.version = "1.0"
  s.author = "Aliaksey Kandratsenka"
  s.email = "alk@tut.by"
  s.require_paths = ["lib"]
  s.files = FileList[
                     'Rakefile',
                     'lib/**/*.rb',
                    ]
  s.has_rdoc = false
  s.description = "pathfixer is a gem plugin that synchronizes gem bindir with /usr/local/bin"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar_gz = true
end
