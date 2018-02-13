# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

module Permissions
  module Scopes
    def self.included(base)
      base.instance_eval do
        class_attribute :relationship_to_scope_to

        def scoped_to(association)
          raise(Permissions::UnknownAssociation, "Cannot find association `#{association}`") unless
            active_record_associations_include?(association)

          self.relationship_to_scope_to = association
        end
      end

      base.class_eval do
        def start_of_permissions_chain
          self.class.where(relationship_to_scope_to => send(relationship_to_scope_to))
        end
      end
    end
  end
end

# rubocop:enable Metrics/MethodLength
