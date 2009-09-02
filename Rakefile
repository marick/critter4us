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
     system("heroku rake local_db_create --app critter4us-staging")
end

task :echo do
     puts "HI"
end

desc "Create Database on this machine."
task :local_db_create do
     puts "1"
#     require 'rubygems'
#     puts "2"
#     require 'path-setting'
#     require 'config'
#     require "admin/create.rb"
end

desc "Deploy new version on staging server."
task :stage do 
     `git push staging master`
end

desc "Push new version into production."
task :deploy do 
     `git push heroku`
end
