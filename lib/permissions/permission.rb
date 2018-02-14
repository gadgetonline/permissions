# frozen_string_literal: true

module Permissions
  class Permission < ActiveRecord::Base
    extend ConcernedWith

    concerned_with(
      :permission_active_record,
      :permission_scopes
    )
  end
end
