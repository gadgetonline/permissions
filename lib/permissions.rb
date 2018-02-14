# frozen_string_literal: true

require 'active_record'
require 'pundit'

require_relative 'permissions/concerned_with'
require_relative 'permissions/exceptions'
require_relative 'permissions/grants'
require_relative 'permissions/permission'
require_relative 'permissions/railtie'
require_relative 'permissions/rules'
require_relative 'permissions/scopes'
require_relative 'permissions/version'

module Permissions
end
