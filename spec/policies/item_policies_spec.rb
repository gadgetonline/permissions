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

  describe 'A set of item grants for a' do
    subject(:items) { ItemPolicy::Scope.new(user_a, Item).readable }

    context 'user with no permissions' do
      it 'yields only the organization\'s items' do
        expect(items).to match_array(items_a)
      end
    end

    context 'user with read access to the Item class' do
      it 'yields all items' do
        user_a.grant :read, on: 'Item', to: user_a
        expect(items).to match_array(items_a + items_b)
      end
    end

    context 'user with read access to specific items' do
      it 'yields only those items' do
        user_a.grant :read, on: items_a.first, to: user_a
        expect(items).to match_array(Array(items_a.first))
      end
    end
  end

  describe 'A set of Store grants for a' do
    subject(:items) { ItemPolicy::Scope.new(user_a, Item).readable }

    context 'user with no access to the Store class' do
      it 'yields the organization items' do
        expect(items).to match_array(items_a)
      end
    end

    context 'user with access to the Store class' do
      it 'yields the items in any store' do
        user_a.grant :read, on: 'Store', to: user_a
        expect(items).to match_array(items_a + [items_b.first])
      end
    end

    context 'user with access to specific stores' do
      fit 'yields only the items in those stores' do
        user_a.grant :read, on: store_b, to: user_a
        ap items
        ap items_b.first
        expect(items).to match_array([items_b.first])
      end
    end
  end
end
