# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include Permissions::Grants
  include Permissions::Rules
  include Permissions::Scopes

  self.abstract_class = true

  def self.active_record_associations_include?(association)
    reflect_on_all_associations.map(&:name).include?(association.to_sym)
  end
end
