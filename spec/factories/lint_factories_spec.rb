# frozen_string_literal: true

RSpec.describe 'Lint factories' do
  include_context 'item migration'
  include_context 'organization migration'
  include_context 'user migration'

  it { FactoryBot.lint }
end
