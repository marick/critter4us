require 'rake'
require 'rake/testtask'
$in_rake = true

require 'rubygems'
require 'sequel'
require 'sequel/extensions/migration'

if ENV['DATABASE_URL']   # Production/Heroku
  DB = Sequel.connect(ENV['DATABASE_URL'])
elsif ENV['RACK_ENV'] == 'test'
  DB = Sequel.postgres("critter4us-test", :host => 'localhost',
                       :user => ENV['C4U_USER'],
                       :password => ENV['C4U_PASS'])
else
  DB = Sequel.postgres("critter4us", :host => 'localhost',
                       :user => ENV['C4U_USER'],
                       :password =>  ENV['C4U_PASS'])
end

task :default => :test_all

desc "Convert coffeescript to javascript"
task :coffee do 
  system("coffee -o public/js2 -c src/coffee")
end

task :test_all => [:test, :spec]



task :spec => [:coffee, :spec_cleanup] do
     runner = (`uname` =~ /Darwin/ ? "" : "xvfb-run")
     system("#{runner} jasmine-headless-webkit -c -j spec/support/jasmine.yml")
end

desc "Way coffeescript is set up doesn't agree with emacs coffeescript-mode"
task :spec_cleanup do
     droppings = "spec/*_spec.js"
     unless Dir[droppings].empty?
          `rm #{droppings}` 
     end       
end

desc "Run tests."
Rake::TestTask.new do | t |
  t.test_files = FileList['test/**/*test*.rb']
end

task :echo do
  puts "HI"
end


def db_url(name)
  "postgres://#{ENV['C4U_USER']}:#{ENV['C4U_PASS']}@localhost/#{name}"
end

def app(name)
  "--app #{name} --confirm #{name}"
end

def fill_local_database(name)
   system("heroku db:pull #{db_url(name)} #{app('critter4us')}")
end		  

desc "Fills the TO database from deployed app"
task :fill do
   fill_local_database(ENV["TO"])
end

desc "Backup critter4us"
task :backup do
   fill_local_database("critter4us-backup")
end

desc "Update staging server with data from production"
task :update_staging do
   fill_local_database("critter4us-refresh-staging")
   system("heroku db:push \
          #{db_url('critter4us-refresh-staging')} #{app('critter4us-staging')}")
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
  require './admin/clear-password'
end

desc "Deploy new version on staging server."
task :stage do 
  `git push staging master`
  system("heroku rake migrate --app critter4us-staging")
end

desc "Push new version into production."
task :deploy => [:backup] do 
  `git push heroku`
  system("heroku rake migrate --app critter4us")
end


# ==============

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

