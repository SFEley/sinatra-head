require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sinatra-head"
    gem.summary = %Q{A Sinatra extension that gets inside your <HEAD>.}
    gem.description = %Q{Sinatra::Head provides class methods and helpers for dynamically controlling the fields in your <HEAD> element that are usually preset in your layout: the page title, stylesheet and javascript assets, etc.  Asset lists are inherited throughout superclasses, subclasses, and within action methods, and basic asset path management is supported.}
    gem.email = "sfeley@gmail.com"
    gem.homepage = "http://github.com/SFEley/sinatra-head"
    gem.authors = ["Stephen Eley"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "yard", ">= 0"
    gem.add_development_dependency "haml", ">= 3"
    gem.add_development_dependency "capybara", ">= 0.3.8"
    
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
