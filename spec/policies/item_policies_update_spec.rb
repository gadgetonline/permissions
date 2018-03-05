# frozen_string_literal: true

RSpec.describe ItemPolicy do
  include_context 'item migration'
  include_context 'organization migration'
  include_context 'store migration'
  include_context 'user migration'

  let!(:items_a)        { create_list :item, 3, organization: organization_a }
  let!(:items_b)        { create_list :item, 2, organization: organization_b }
  let!(:organization_a) { create :organization }
  let!(:organization_b) { create :organization }
  let!(:store_a)        { create :store, items: [items_a.first], organization: organization_a }
  let!(:store_b)        { create :store, items: [items_b.first], organization: organization_b }
  let!(:user_a)         { create :user, organization: organization_a }
  let!(:user_b)         { create :user, organization: organization_b }

  describe 'The updateable policy for a' do
    subject(:allowed) { ItemPolicy.new(user_a, items_a.first).update? }

    context 'user and item' do
      it 'returns false if not updateable' do
        expect(allowed).to be_falsey
      end

      it 'returns true if updateable' do
        user_a.grant :update, on: items_a.first, to: user_a
        expect(allowed).to be_truthy
      end

      it 'returns false if the item is not yet available' do
        items_a.first.update_attribute(:available_at, Time.current.tomorrow)
        user_a.grant :update, on: items_a.first, to: user_a
        expect(allowed).to be_falsey
      end

      it 'returns false if the item is expired' do
        items_a.first.update_attribute(:expires_at, Time.current.yesterday)
        user_a.grant :update, on: items_a.first, to: user_a
        expect(allowed).to be_falsey
      end

      it 'returns false if the item is expired' do
        items_a.first.update_attribute(:hidden, true)
        user_a.grant :update, on: items_a.first, to: user_a
        expect(allowed).to be_falsey
      end
    end
  end

  describe 'The updateable policy scope for a' do
    subject(:items) { ItemPolicy::Scope.new(user_a, Item).writeable }

    context 'user with no permissions' do
      it 'yields no items' do
        expect(items).to be_empty
      end
    end

    context 'user with read access to the Item class' do
      it 'yields all items' do
        user_a.grant :update, on: 'Item', to: user_a
        expect(items).to match_array(items_a + items_b)
      end
    end

    context 'user with read access to specific items' do
      it 'yields only those items' do
        user_a.grant :update, on: items_a.first, to: user_a
        expect(items).to match_array(Array(items_a.first))
      end
    end

    context 'user with access to the Store class' do
      it 'yields the items in any store' do
        user_a.grant :update, on: 'Store', to: user_a
        expect(items).to match_array([items_a.first, items_b.first])
      end
    end

    context 'user with access to specific stores' do
      it 'yields only the items in those stores' do
        user_a.grant :update, on: store_b, to: user_a
        expect(items).to match_array([items_b.first])
      end
    end

    context 'user with specific grants to organizations' do
      it 'yields the specific organization\'s items' do
        user_a.grant :update, on: organization_b, to: user_a
        expect(items).to match_array(items_b)
      end

      it 'yields the combined organizations\' items' do
        user_a.grant :update, on: organization_a, to: user_a
        user_a.grant :update, on: organization_b, to: user_a
        expect(items).to match_array(items_a + items_b)
      end
    end
  end
end
