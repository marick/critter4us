require 'rake'
require 'rake/testtask'

task :default => :test

desc "Run tests."
Rake::TestTask.new do | t |
  t.test_files = FileList['test/**/*tests.rb']
end

desc "Create Database"
task :db_create do
     require 'rubygems'
     puts 'gems loaded'
     require 'path-setting'
     puts 'path-setting'
     require 'config'
     puts 'config'
     require "admin/create.rb"
     puts 'admin/create'
end

task :echo do 
     puts "help"
end

task :deploy do 
     `git push heroku`
end
