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
     require 'path-setting'
     require 'config'
     require "admin/create.rb"
end

task :echo do 
     puts "help"
end

task :deploy do 
     `git push heroku`
end
