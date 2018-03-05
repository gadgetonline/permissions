# frozen_string_literal: true

class PolicyHelper
  def initialize(initial_scope, permissions_scope)
    @scope             = initial_scope
    @permissions_scope = permissions_scope
  end

  def accessible
    @scope.none
  end

  private

  attr_reader :permissions_scope
end
