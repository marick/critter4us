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


# You can't migrate directly from 0 to 2.
desc "migrate database from version 0 to 1 (hack)"
task :migrate1 do
  migrate(1, 0)
end

desc "migrate from version 1 to 2 (hack)"
task :migrate2 do
  migrate(2, 1)
end

desc "migrate from FROM to TO (both are optional)"
task :migrate do
   migrate(i_or_nil('TO'), i_or_nil('FROM'))
end

desc "show current migration version"
task :migration_version do 
  puts Sequel::Migrator.get_current_migration_version(DB)
end  

desc "make current migration version TO without actually running the migrations"
task :set_migration_version do 
     Sequel::Migrator.set_current_migration_version(DB, i('TO'))
     system('rake migration_version')
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

def migrate(to=nil, from = nil)
  puts "Migrate from #{from.inspect} to #{to.inspect}."
  Sequel::Migrator.apply(DB, 'migrations', to, from)
end

def i(name)
  i_with_nil(name) do 
    STDERR.puts("#{name} must be given.")
    exit 1
 end   
end

def i_or_nil(name)
  i_with_nil(name) do 
    nil
  end
end

def i_with_nil(name)
  value = ENV[name]
  return yield if value.nil?
  value.to_i
end

