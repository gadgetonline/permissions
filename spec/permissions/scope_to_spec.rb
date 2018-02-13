# frozen_string_literal: true

RSpec.describe 'relationship_to_scope_to features' do
  include_context 'item migration'
  include_context 'organization migration'

  describe 'scope_to' do
    let(:organization) { Organization.create name: 'O' }

    it 'works' do
      item = Item.create name: 'I', organization: organization
    end
  end
end
