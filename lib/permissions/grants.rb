# frozen_string_literal: true

module Permissions
  module Grants
    def self.included(base)
      base.instance_eval do
        def readable_by(association, *associations)
          class_attribute :perms

          ([association] + associations).each do |assoc|
            raise(Permissions::UnknownAssociation, "Cannot find association `#{assoc}`") unless
              active_record_associations_include?(assoc)
          end

          perms ||= {}
        end

        private

        def active_record_associations_include?(association)
          reflect_on_all_associations.map(&:name).include?(association.to_sym)
        end
      end

      base.class_eval do
        def grant(right, on:, to:)
          right
          to
          on
        end
      end
    end
  end
end
