# frozen_string_literal: true

require 'bundler'
require 'juwelier'
require 'rake'
require 'rdoc/task'
require 'rubygems'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end

Juwelier::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/
  # for more options
  gem.name        = 'permission'
  gem.homepage    = 'http://github.com/gadgetonline/permission'
  gem.license     = 'MIT'
  gem.summary     = 'Define fine-grained access control on Active Record models'
  gem.description = 'Define fine-grained access control on Active Record models'
  gem.email       = 'martin.streicher@gmail.com'
  gem.authors     = ['Martin Streicher']
end

Juwelier::RubygemsDotOrgTasks.new

desc 'Code coverage detail'
task :simplecov do
  ENV['COVERAGE'] = 'true'
  Rake::Task['test'].execute
end

task default: :test

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ''

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "permission #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
