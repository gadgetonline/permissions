# frozen_string_literal: true

class ItemPolicy < ApplicationPolicy
  class Scope < Scope
    def readable
      initial_scope     = default_scope scope
      permissions_scope = user.permissions.read_right
      analyze initial_scope, permissions_scope
    end

    def writeable
      initial_scope     = Item.none
      permissions_scope = user.permissions.update_right
      analyze initial_scope, permissions_scope
    end

    alias destroyable writeable
    alias updateable writeable

    private

    def analyze(initial_scope, permissions_scope)
      ItemPolicyHelper.new(
        initial_scope,
        permissions_scope
      ).accessible
    end

    def default_scope(initial_scope) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      arel_table          = Arel::Table.new(:items)
      available_at_column = arel_table[:available_at]
      expires_at_column   = arel_table[:expires_at]
      conditions          = {
        Item.relationship_to_scope_to => user.send(Item.relationship_to_scope_to)
      }

      initial_scope
        .where(conditions)
        .where(hidden: false)
        .where(available_at_column.lt(Time.current).or(available_at_column.eq(nil)))
        .where(expires_at_column.gt(Time.current).or(expires_at_column.eq(nil)))
    end
  end

  def create?
    user
      .permissions
      .permissions_for_class(Item, Organization, Store)
      .exist?
  end

  def destroy?
    permitted? :destroyable, record
  end

  def read?
    permitted? :readable, record
  end

  def write?
    permitted? :updateable, record
  end

  private

  def permitted?(accessible, record)
    ItemPolicy::Scope
      .new(user, Item)
      .send(accessible)
      .where(id: record)
      .exists?
  end
end
