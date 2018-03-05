# frozen_string_literal: true

require_relative 'policy_helper'

class ItemPolicyHelper < PolicyHelper
  def accessible
    accessible_items_scope = @scope

    if permissions_scope.any?
      accessible_items_scope = scope_for_permitted_items accessible_items_scope
      accessible_items_scope = scope_for_permitted_stores accessible_items_scope
      accessible_items_scope = scope_for_permitted_organizations accessible_items_scope
    end

    accessible_items_scope
  end

  private

  def scope_for_permitted_items(initial_scope)
    return Item.all if permissions_scope.permissions_for_class(Item).exists?

    ids            = permissions_scope.permissions_for_instances(Item).pluck(:object_id)
    specific_scope = Item.where(id: ids)
    ids.any? ? specific_scope : initial_scope
  end

  def scope_for_permitted_organizations(initial_scope)
    return Item.all if permissions_scope.permissions_for_class(Organization).exists?
    return initial_scope if permissions_scope.permissions_for_instances(Organization).empty?

    ids            = permissions_scope.permissions_for_instances(Organization).pluck(:object_id)
    specific_scope = Item.where(organization_id: ids)
    ids.any? ? specific_scope : initial_scope
  end

  def scope_for_permitted_stores(initial_scope)
    if permissions_scope.permissions_for_class(Store).exists?
      expanded_scope = Item.where.not(store_id: nil)
      return initial_scope.union(expanded_scope)
    end

    if permissions_scope.permissions_for_instances(Store).any?
      ids            = permissions_scope.permissions_for_instances(Store).pluck(:object_id)
      specific_scope = Item.where(store_id: ids)
      return specific_scope if ids.any?
    end

    initial_scope
  end
end
