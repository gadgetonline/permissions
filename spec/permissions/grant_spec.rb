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

  describe 'records access' do
    let(:widget) { Widget.create name: 'Cheese' }

    subject(:grant) { widget.grant :read, on: Store, to: widget }

    context 'for a class' do
      it 'creates an entry' do
        expect { grant }.to(change { Permissions::Permission.count }.by(1))
      end

      it 'with the right object name' do
        grant
        expect(Permissions::Permission.last.object_type).to eq('Store')
      end

      it 'with an object ID of nil' do
        grant
        expect(Permissions::Permission.last.object_id).to be_nil
      end

      it 'with the proper grantee class name' do
        grant
        expect(Permissions::Permission.last.grantee_type).to eq('Widget')
      end

      it 'with the proper grantee ID' do
        grant
        expect(Permissions::Permission.last.grantee_id).to eq(widget.id)
      end
    end
  end
end
