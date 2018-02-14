# frozen_string_literal: true

RSpec.describe ItemPolicy do
  include_context 'item migration'
  include_context 'organization migration'
  include_context 'user migration'

  let!(:items_a)        { create_list :item, 3, organization: organization_a }
  let!(:items_b)        { create_list :item, 2, organization: organization_b }
  let!(:organization_a) { create :organization }
  let!(:organization_b) { create :organization }
  let!(:user_a)         { create :user, organization: organization_a }
  let!(:user_b)         { create :user, organization: organization_b }

  describe 'allows' do
    subject(:items) { ItemPolicy::Scope.new(user_a, Item).readable }

    context 'user with no permissions' do
      it 'to have access only to organization\'s items' do
        expect(items).to match_array(items_a)
      end
    end

    context 'user with access to the Item class' do
      it 'to have access to all items' do
        user_a.grant :readable, on: 'Item', to: user_a
        expect(items).to match_array(items_a + items_b)
      end
    end
  end
end
