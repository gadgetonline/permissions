# frozen_string_literal: true

FactoryBot.define do
  factory :permission, class: 'Permissions::Permission' do
    grantee_type  'PlaceHolder'
    grantee_id
    object_type   'Widget'
  end
end
