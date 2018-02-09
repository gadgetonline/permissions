# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

module Permissions
  module Controls
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
    end
  end
end

# rubocop:enable Metrics/MethodLength
