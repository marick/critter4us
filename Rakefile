require 'rake'
require 'rake/testtask'
$in_rake = true

require 'rubygems'
require 'sequel'
require 'sequel/extensions/migration'
unless ENV['DATABASE_URL']
  DB = Sequel.postgres("critter4us", :host => 'localhost',
                       :user => 'postgres',
                       :password =>  'c0wm4gnet')
else
  DB = Sequel.connect(ENV['DATABASE_URL'])
end


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
  require 'rubygems'
  require 'path-setting'
  require 'config'
  require "admin/create.rb"
end

desc "Reset database on this machine"
task :db_reset do
  require 'rubygems'
  require "admin/reset-db.rb"
end


desc "migrate from version 0 to 1 (hack)"
task :migrate1 do
  migrate(1, 0)
end

desc "migrate from version 1 to 2 (hack)"
task :migrate2 do
  migrate(2, 1)
end

desc "Clear password on this machine"
task :clear_password do 
  require 'admin/clear-password'
end

desc "Deploy new version on staging server."
task :stage do 
  `git push staging master`
end

desc "Push new version into production."
task :deploy do 
  `git push heroku`
end

def migrate(to, from = nil)
  Sequel::Migrator.apply(DB, 'migrations', to, from)
end
