# frozen_string_literal: true

class Base < ApplicationRecord
  include Permissions::Grants

  self.abstract_class = true
end
