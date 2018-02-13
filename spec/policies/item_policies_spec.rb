# frozen_string_literal: true

RSpec.describe ItemPolicy do
  include_context 'item migration'
  include_context 'organization migration'

  let!(:items)        { create_list :item, 3, organization: organization }
  let!(:organization) { create :organization }
end
