# frozen_string_literal: true

module Permissions
  class Permission < ActiveRecord::Base
    def self.permission_for_class(klass)
      class_name = klass_to_string klass
      conditions = { object_type: class_name, object_id: nil }

      where conditions
    end

    def self.permissions_for_instances(klass)
      class_name = klass_to_string klass
      conditions = { object_type: class_name }

      where(conditions)
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
