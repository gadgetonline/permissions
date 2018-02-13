# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'permissions/version'

Gem::Specification.new do |spec|
  spec.authors       = ['Martin Streicher']
  spec.description   = 'Define fine-grained access control on Active Record models'
  spec.email         = ['martin.streicher@gmail.com']
  spec.homepage      = 'https://github.com/gadgetonline/permissions'
  spec.license       = 'MIT'
  spec.name          = 'permissions'
  spec.summary       = 'Define fine-grained access control on Active Record models'
  spec.version       = Permissions::Version::VERSION

  spec.add_dependency 'activerecord'
  spec.add_dependency 'active_record_union'
  spec.add_dependency 'pundit'

  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'factory_bot_rails'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'guard-spring'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rdoc'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'table_print'

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ['lib']
end
