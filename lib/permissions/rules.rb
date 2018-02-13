# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

module Permissions
  module Rules
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
      end
    end
  end
end

# rubocop:enable Metrics/MethodLength
