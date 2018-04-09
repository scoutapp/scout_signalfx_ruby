require "bundler/gem_tasks"
require 'rake/testtask'

# Rake::TestTask.new do |t|
#   t.libs << 'test'
# end

task :test do
  $: << File.expand_path(File.dirname(__FILE__) + "/test")
  Dir.glob('./test/*_test.rb').each { |file| require file }
end

desc "Run tests"
task :default => :test
