require 'rake'
require 'rake/testtask'
$in_rake = true

task :default => :test

desc "Run tests."
Rake::TestTask.new do | t |
  t.test_files = FileList['test/**/*tests.rb']
end

desc "Create Database on staging server." 
task :staging_db_create do 
     `heroku rake local_db_create --app critter4us-staging`
end

desc "Create Database on this machine."
task :local_db_create do
     require 'rubygems'
     require 'path-setting'
     require 'config'
     require "admin/create.rb"
end

task :stage do 
     `git push staging master`
end

task :deploy do 
     `git push heroku`
end
