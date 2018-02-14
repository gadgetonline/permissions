# frozen_string_literal: true

class User < Base
  belongs_to :organization
  has_many :permissions, as: :grantee, class_name: 'Permissions::Permission'
end
