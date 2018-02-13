# frozen_string_literal: true

class Item < Base
  belongs_to :organization
  has_many :stores

  scoped_to :organization
end
