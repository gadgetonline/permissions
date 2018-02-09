# frozen_string_literal: true

module Permissions
  class Permission < ActiveRecord::Base
    belongs_to :grantee, polymorphic: true
  end
end
