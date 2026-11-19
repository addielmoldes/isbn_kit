# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = ["test/**/*_test.rb"]
  t.verbose = true
end

RuboCop::RakeTask.new

task default: %i[test rubocop]
