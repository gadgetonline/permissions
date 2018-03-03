# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

module Permissions
  module Grants
    class ClassInformation
      attr_reader :id, :type

      def initialize(object)
        (@type, @id) =
          if object.is_a?(Class)
            [object.name, nil]
          elsif object.is_a?(String)
            [object, nil]
          else
            [object.class.name, object.id]
          end
      end
    end

    def self.included(base)
      base.class_eval do
        def grant(right, on:, to:)
          object  = typify on
          grantee = typify to

          conditions = {
            grantee_id:   grantee.id,
            grantee_type: grantee.type,
            object_id:    object.id,
            object_type:  object.type,
            right:        right
          }

          Permissions::Permission.where(conditions).first_or_create!
        end

        private

        def typify(item)
          Permissions::Grants::ClassInformation.new item
        end
      end
    end
  end
end

# rubocop:enable Metrics/MethodLength
