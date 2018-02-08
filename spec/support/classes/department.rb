# frozen_string_literal: true

class Department < Base
  has_many :groups
  has_many :people, through: :groups
end
