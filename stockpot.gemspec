# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "stockpot/version"

Gem::Specification.new do |spec|
  spec.name          = "stockpot"
  spec.version       = Stockpot::VERSION
  spec.authors       = [ "Jayson Smith" ]
  spec.email         = [ "gh@nes.33mail.com" ]

  spec.summary       = "Makes setting up test data in your Rails database from an external resource easier."
  spec.description   = "Exposes a few end points from your app, easily enabling CRUD actions on your database that you can utilize from things like a standalone test suite to set up state. (think: Cypress, Cucumber, etc.)"
  spec.homepage      = "https://github.com/Freshly/stockpot"
  spec.license       = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/Freshly/stockpot/blob/master/CHANGELOG.md"

  spec.files = Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  spec.require_paths = "lib"

  spec.add_dependency "rails", "5.2.3"
  spec.add_dependency "factory_bot_rails", "~> 5.1.0"
  spec.add_dependency "database_cleaner", "~> 1.6.2"
  spec.add_dependency "redis", "~> 3.3.5"
  spec.add_dependency "timecop", "~> 0.8"

  spec.add_development_dependency "pry-byebug", "~> 3.7"
  spec.add_development_dependency "rake", "~> 12.3", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "rspec-rails", "~> 3.8", ">= 3.8.2"
  spec.add_development_dependency "spicerack-styleguide", ">= 0.16.2", "< 1.0"
  spec.add_development_dependency "shoulda-matchers", "~> 4.1", ">= 4.1.2"
  spec.add_development_dependency "simplecov", "~> 0.17.1"
end
