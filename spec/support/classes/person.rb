# frozen_string_literal: true

class Person < Base
  has_many :groups

  readable_by :groups
end
