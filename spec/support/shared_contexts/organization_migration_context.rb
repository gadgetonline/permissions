# frozen_string_literal: true

RSpec.shared_context 'organization migration' do
  after(:all) do
    ActiveRecord::Migration.drop_table :organizations
  end

  before(:all) do
    ActiveRecord::Migration.create_table :organizations, force: true do |t|
      t.string :name, default: nil, required: false
    end

    begin
      DatabaseCleaner.start
      FactoryBot.lint(FactoryBot.factories.select { |f| f.name.to_s.start_with?('organization') })
    ensure
      DatabaseCleaner.clean
    end
  end
end
