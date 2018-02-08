# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
ENV['DB']        ||= 'sqlite'

require File.expand_path('../support/skeleton/config/environment', __FILE__)
require 'byebug'
require 'database_cleaner'
require 'faker'
require 'permissions'
require 'rspec/rails'

DatabaseCleaner.strategy = :transaction

Dir[File.join(File.expand_path('../support', __FILE__), '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  Kernel.srand config.seed

  config.after  { DatabaseCleaner.clean }
  config.before { DatabaseCleaner.start }

  config.disable_monkey_patching!
  config.example_status_persistence_file_path = 'spec/status.txt'

  # rspec-expectations config goes here. You can use an alternate
  # assertion/expectation library such as wrong or the stdlib/minitest
  # assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.filter_run_when_matching :focus

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  config.order = :random
  config.profile_examples = 10

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.use_transactional_fixtures = true
  config.warnings = true
end
