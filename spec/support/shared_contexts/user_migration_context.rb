# frozen_string_literal: true

RSpec.shared_context 'user migration' do
  after(:all) do
    ActiveRecord::Migration.drop_table :users
  end

  before(:all) do
    ActiveRecord::Migration.create_table :users, force: true do |t|
      t.string      :name,         default: nil,   required: false
      t.belongs_to  :organization, required: true, index: true
    end

    begin
      DatabaseCleaner.start
      FactoryBot.lint(FactoryBot.factories.select { |f| f.name.to_s.start_with?('user') })
    ensure
      DatabaseCleaner.clean
    end
  end
end
