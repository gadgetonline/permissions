# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include Permissions::Controls
  include Permissions::Grants

  self.abstract_class = true
end
