# frozen_string_literal: true

class Organization < Base
  has_many :stores
  has_many :items
end
