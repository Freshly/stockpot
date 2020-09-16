# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in stockpot.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

group :test do
  gem "rails", ">= 5.2.3"
  gem "factory_bot_rails", "~> 5.1.0"
  gem "redis", ">= 3.3.5"
  gem "timecop", "~> 0.8"
  gem "pg", "~>0.18.4"
  gem "database_cleaner-active_record"
  gem "database_cleaner-redis"
  gem "pry-byebug", "~> 3.7"
  gem "rake", '~> 13.0', '>= 13.0.1'
  gem "rspec", '~> 3.9'
  gem "rspec-rails", '~> 3.9'
  gem "spicerack-styleguide", ">= 0.21.0", "< 1.0"
  gem "shoulda-matchers", "~> 4.1", ">= 4.1.2"
  gem "simplecov", "~> 0.17.1"
end
