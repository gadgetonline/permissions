# frozen_string_literal: true

class ItemPolicy < ApplicationPolicy
  class Scope < Scope
    def readable
      readable_scope = no_permissions_scope(scope)

      byebug
      if user.permissions.any?
        readable_scope = scope_for_permitted_items readable_scope
        readable_scope = scope_for_permitted_stores readable_scope
        readable_scope = scope_for_permitted_organizations readable_scope
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
      arel_table[:available_at]
    end

    def no_permissions_scope(initial_scope)
      conditions = { Item.relationship_to_scope_to => user.send(Item.relationship_to_scope_to) }
      readable_scope = initial_scope.where conditions

      readable_scope
        .where(hidden: false)
        .where(available_column.gt(Time.current).or(available_column.eq(nil)))
    end

    def limit_to_organization_scope
      conditions = { Item.relationship_to_scope_to => user.send(Item.relationship_to_scope_to) }
      scope.where conditions
    end

    def scope_for_permitted_items(initial_scope) # rubocop:disable Metrics/AbcSize
      return(scope.all) if user.permissions.permission_for_class(Item).exists?
      return(initial_scope) if user.permissions.permissions_for_instances(Item).empty?

      ids = user.permissions.permissions_for_instances(Item).pluck(:object_id)
      Item.where(id: ids)
    end

    def scope_for_permitted_organizations(initial_scope) # rubocop:disable Metrics/AbcSize
      return(scope.all) if user.permissions.permission_for_class(Organization).exists?
      return(initial_scope) if user.permissions.permissions_for_instances(Organization).empty?

      ids            = user.permissions.permission_for_instances(Organization).pluck(:object_id)
      expanded_scope = Item.where(organization_id: ids)
      initial_scope.union expanded_scope
    end

    def scope_for_permitted_stores(initial_scope) # rubocop:disable Metrics/AbcSize
      modified_scope = initial_scope

      if user.permissions.permission_for_class(Store).exists?
        expanded_scope = Item.where.not(store_id: nil)
        return(modified_scope.union(expanded_scope))
      end

      if user.permissions.permissions_for_instances(Store).any?
        ids            = user.permissions.permissions_for_instances(Store).pluck(:object_id)
        expanded_scope = Item.where(store_id: ids)
        initial_scope.union expanded_scope
      end

      modified_scope
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
