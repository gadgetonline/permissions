# frozen_string_literal: true

module Permissions
  module Grants
    def self.included(base)
      base.instance_eval do
        def readable_by(association, *associations)
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
