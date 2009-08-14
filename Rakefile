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
     echo 'gems loaded'
     require 'path-setting'
     echo 'path-setting'
     require 'config'
     echo 'config'
     require "admin/create.rb"
     echo 'admin/create'
end

task :echo do 
     puts "help"
end

task :deploy do 
     `git push heroku`
end
