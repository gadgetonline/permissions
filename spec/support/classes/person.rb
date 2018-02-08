# frozen_string_literal: true

class Person < Base
  has_many :groups
  has_many :departments, through: :groups
end
