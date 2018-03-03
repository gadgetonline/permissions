# frozen_string_literal: true

module Permissions
  class Permission < ActiveRecord::Base
    REFERENCE_PAIRS = { grantee_type: :grantee_id, object_type: :object_id }
    UNKNOWN_CLASS_ERROR_MESSAGE = 'is not a known class'

    # Do not alter the values assigned to each key.
    # Remove and add pairs, but do not change the value of a key.
    enum right: {
      create:  1,
      destroy: 2,
      grant:   3,
      read:    0,
      update:  4
    }, _suffix: true

    belongs_to :grantee, polymorphic: true

    validate :references_exist, if: -> { grantee_type && object_type }
    validates :grantee_id,   presence: true
    validates :grantee_type, presence: true
    validates :object_type,  presence: true

    private

    def references_exist
      REFERENCE_PAIRS.each do |(type_field, id_field)|
        klass = send(type_field).to_s.safe_constantize

        if klass.nil?
          errors.add(type_field, UNKNOWN_CLASS_ERROR_MESSAGE)
          next
        end

        id = send(id_field) || next

        errors.add(id_field, 'instance does not exist') if
          id && klass.find_by(id: id).nil?
      end
    end
  end
end
