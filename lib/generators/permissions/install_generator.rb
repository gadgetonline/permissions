# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/active_record'

module Permissions
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    source_root File.expand_path('../templates', __FILE__)

    desc 'Generates, but does not run, a migration to add a permissios table.'

    def create_migration_file
      add_permissions_migration 'create_permissions'
    end

    protected

    def add_permissions_migration(template)
      migration_dir = File.expand_path('db/migrate')

      if self.class.migration_exists?(migration_dir, template)
        ::Kernel.warn "Migration already exists: #{template}"
        return
      end

      migration_template(
        "#{template}.rb.erb",
        "db/migrate/#{template}.rb",
        migration_version: migration_version
      )
    end

    private

    def migration_version
      major = ActiveRecord::VERSION::MAJOR
      "[#{major}.#{ActiveRecord::VERSION::MINOR}]" if major >= 5
    end
  end
end
