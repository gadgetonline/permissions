# frozen_string_literal: true

class Group < Base
  belongs_to :department
  has_many :people
end
