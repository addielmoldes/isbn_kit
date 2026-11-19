# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
end

RuboCop::RakeTask.new

task default: %i[test rubocop]
