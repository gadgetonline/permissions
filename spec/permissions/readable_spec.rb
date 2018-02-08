# frozen_string_literal: true

RSpec.describe 'readable features' do
  after(:all) do
    ActiveRecord::Migration.drop_table :items
  end

  before(:all) do
    ActiveRecord::Migration.create_table :items, force: true do |t|
      t.string :name, default: nil, required: false
    end
  end

  it 'works' do
  end
end
