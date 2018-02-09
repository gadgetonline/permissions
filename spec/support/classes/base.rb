# frozen_string_literal: true

require_relative 'application_record'

class Base < ApplicationRecord
  self.abstract_class = true
end
