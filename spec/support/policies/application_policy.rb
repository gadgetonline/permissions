# frozen_string_literal: true

class ApplicationPolicy
  class Scope
    attr_reader :scope, :user

    def initialize(user, scope)
      @user  = user
      @scope = scope
    end
  end

  attr_reader :record, :user

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, 'must be logged in' unless user

    @user   = user
    @record = record
  end
end
