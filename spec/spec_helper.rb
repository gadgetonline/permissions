# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
ENV['RAILS_ENV'] ||= 'test'

require 'active_record'
require 'awesome_print'
require 'bundler/setup'
require 'byebug'
require 'database_cleaner'
require 'factory_bot_rails'
require 'faker'
require 'permissions'
require 'shoulda'
require 'table_print'

Dir[File.join(File.expand_path('../support', __FILE__), '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  Kernel.srand config.seed

  config.after(:each) { DatabaseCleaner.clean }

  config.after(:all) do
    ActiveRecord::Migration.drop_table :permissions
  end

  config.before(:all) do
    ActiveRecord::Base.establish_connection(
      adapter:  'sqlite3',
      database: ':memory:'
    )

    ActiveRecord::Migration.create_table  :permissions, force: true do |t|
      t.datetime :created_at,   required: true
      t.datetime :expires_at,   required: false, default: nil
      t.string   :grantee_type, required: true
      t.integer  :grantee_id,   required: false, default: nil
      t.string   :object_type,  required: true
      t.integer  :object_id,    required: false, default: nil
      t.integer  :right,        required: true,  default: 0
    end

    #   add_index :permissions, %i[object_type object_id]
    #   add_index :permissions, %i[grantee_type grantee_id]
    # end
  end

  config.before(:each) { DatabaseCleaner.start }

  config.before(:suite) do
    FactoryBot.reload
  end

  config.disable_monkey_patching!
  config.example_status_persistence_file_path = 'spec/status.txt'

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end

  config.filter_run_when_matching :focus
  config.include FactoryBot::Syntax::Methods

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random
  config.profile_examples = 10
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.warnings = true
end

# rubocop:enable Metrics/BlockLength
