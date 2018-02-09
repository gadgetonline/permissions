# frozen_string_literal: true

require 'rails'

module Permissions
  class Railtie < Rails::Railtie
    generators do
      require File.expand_path('../generators/permissions/install_generator', __FILE__)
    end
  end
end
