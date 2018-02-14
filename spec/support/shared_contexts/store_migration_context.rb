# frozen_string_literal: true

RSpec.shared_context 'store migration' do
  after(:all) do
    ActiveRecord::Migration.drop_table :stores
  end

  before(:all) do
    ActiveRecord::Migration.create_table :stores, force: true do |t|
      t.string      :name,         default: nil,   required: false
      t.belongs_to  :organization, required: true, index: true
    end

    begin
      DatabaseCleaner.start
      FactoryBot.lint(FactoryBot.factories.select { |f| f.name.to_s.start_with?('store') })
    ensure
      DatabaseCleaner.clean
    end
  end
end
