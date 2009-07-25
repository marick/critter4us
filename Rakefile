require 'rake'
require 'rake/testtask'

task :default => :test

desc "Run tests."
Rake::TestTask.new do | t |
  t.test_files = FileList['test/**/*tests.rb']
end
