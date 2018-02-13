# frozen_string_literal: true

require 'pundit'
require_relative 'application_record'

class Base < ApplicationRecord
  include Pundit

  self.abstract_class = true
end
