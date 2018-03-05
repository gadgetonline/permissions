# frozen_string_literal: true

module Permissions
  class Permission < ActiveRecord::Base
    def self.permissions_for_class(*klasses, right: nil)
      class_names       = klasses.map { |klass| klass_to_string klass }
      conditions        = { object_type: class_names, object_id: nil }
      permissions_scope = right ? send(right) : self
      permissions_scope.where conditions
    end

    def self.permissions_for_instances(*klasses, right: nil)
      class_names       = klasses.map { |klass| klass_to_string klass }
      conditions        = { object_type: class_names }
      permissions_scope = right ? send(right) : self
      permissions_scope
        .where(conditions)
        .where.not(object_id: nil)
    end

    def self.klass_to_string(klass)
      case klass.class
      when Class
        klass.name
      when String
        klass
      when Object
        klass.class.name
      end
    end
  end
end
