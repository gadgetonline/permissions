# frozen_string_literal: true

class ItemPolicy < ApplicationPolicy
  class Scope < Scope
    def readable
      readable_scope =
        scope.where(Item.relationship_to_scope_to => user.send(Item.relationship_to_scope_to))

      if user.permissions.any?
        # union readable_scope with another scope
      else
        readable_scope =
          readable_scope
          .where(hidden: false)
          .where(available_column.gt(Time.current))
      end

      readable_scope
    end

    def writeable
      writeable_scope = Item.none

      writeable_scope
    end

    private

    def arel_table
      Arel::Table.new(:items)
    end

    def available_column
      arel_table[:available]
    end
  end

  def create?
  end

  def destroy?
  end

  def read?
    item_policy_scope.readable.where(id: record).exists?
  end

  def write?
  end

  private

  def item_policy_scope
    ItemPolicy::Scope.new(user, Item)
  end
end
