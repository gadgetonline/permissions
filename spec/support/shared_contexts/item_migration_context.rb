# frozen_string_literal: true

RSpec.shared_context 'item migration' do
  after(:all) do
    ActiveRecord::Migration.drop_table :items
  end

  before(:all) do
    ActiveRecord::Migration.create_table :items, force: true do |t|
      t.datetime    :available_at, default: nil,    required: false, index: true
      t.datetime    :expires_at,   default: nil,    required: false, index: true
      t.boolean     :hidden,       default: false,  required: false, index: true
      t.string      :name,         default: nil,    required: false
      t.belongs_to  :organization, required: true,  index: true
      t.belongs_to  :store,        required: false, index: true
    end

    begin
      DatabaseCleaner.start
      FactoryBot.lint(FactoryBot.factories.select { |f| f.name.to_s.start_with?('item') })
    ensure
      DatabaseCleaner.clean
    end
  end
end
