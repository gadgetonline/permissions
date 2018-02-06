# frozen_string_literal: true

module Permissions
  module Version
    MAJOR = 1
    MINOR = 2
    PATCH = 3
    BUILD = 'pre3'

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end
