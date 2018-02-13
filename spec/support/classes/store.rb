# frozen_string_literal: true

class Store < Base
  belongs_to :organization
  has_many :items
end
