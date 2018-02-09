# frozen_string_literal: true

RSpec.describe 'grant features' do
  after(:all) do
    ActiveRecord::Migration.drop_table :widgets
  end

  before(:all) do
    ActiveRecord::Migration.create_table :widgets, force: true do |t|
      t.string :name, default: nil, required: false
    end
  end

  class Widget < ApplicationRecord
  end

  def widget
    Widget.new name: 'Cheese'
  end

  describe 'records access' do
    subject(:grant) { widget.grant :readable, on: Group, to: widget }

    context 'for a class' do
      specify 'creates an entry' do
        expect { grant }.to(change { Permissions::Permission.count }.by(1))
      end

      specify 'with the right object name' do
        grant
        expect(Permissions::Permission.last.object_type).to eq('Group')
      end

      specify 'with an object ID of nil' do
        grant
        expect(Permissions::Permission.last.object_id).to be_nil
      end

      specify 'with the proper grantee class name' do
        grant
        expect(Permissions::Permission.last.grantee_type).to eq('Widget')
      end

      specify 'with the proper grantee ID' do
        grant
        expect(Permissions::Permission.last.grantee_id).to eq(widget.id)
      end
    end
  end
end
