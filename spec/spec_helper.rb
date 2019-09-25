# frozen_string_literal: true

require "bundler/setup"
require "simplecov"
require "pry-byebug"
require 'rails'
require "shoulda-matchers"

require "stockpot"
require_relative './support/assertion_helpers'

RSpec.configure do |config|
  config.include AssertionHelpers

  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Allow for running or skipping specific specs by prepending
  # with f or x on it
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.before(:each) { Redis.new.flushdb if defined?(Redis) }
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
  end
end
