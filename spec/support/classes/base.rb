# frozen_string_literal: true

require_relative 'application_record'

class Base < ApplicationRecord
  include Permissions::Grants

  self.abstract_class = true
end
