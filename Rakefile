require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
gem "spicycode-micronaut", ">= 0.2.10"
require 'micronaut'
require 'micronaut/rake_task'

desc "Run all micronaut examples"
Micronaut::RakeTask.new :examples do |t|
  t.pattern = "examples/**/*_example.rb"
end

namespace :examples do
  desc "Run all micronaut examples using rcov"
  Micronaut::RakeTask.new :coverage do |t|
    t.pattern = "examples/**/*_example.rb"
    t.rcov = true
    t.rcov_opts = %[--exclude "gems/*,/Library/Ruby/*,config/*" --text-summary  --sort coverage]
  end
  
  RAILS_VERSIONS = %w[2.0.2 2.1.0 2.1.1 2.2.2 2.3.1 2.3.2]
  
  desc "Run exmaples with multiple versions of rails"
  task :multi_rails do
    RAILS_VERSIONS.each do |rails_version|
      puts
      sh "RAILS_VERSION='#{rails_version}' rake examples"
    end
  end
end

if ENV["RUN_CODE_RUN"]
  task :default => "examples:multi_rails"
else
  task :default => "examples:coverage"
end

desc 'Generate documentation for the safe_erb plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SafeERB'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
