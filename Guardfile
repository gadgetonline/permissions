# frozen_string_literal: true

directories %w[. lib spec]

guard :rspec, cmd: 'bundle exec rspec', title: 'Permissions Test Results' do
  group :configuration do
    watch('.rspec')               { 'spec' }
    watch('spec/spec_helper.rb')  { 'spec' }
  end

  group :lib do
    watch(%r{^lib/(.+)\.rb$}) { |m| 'spec/permissions' }
  end

  group :specfiles do
    watch(/.+_spec\.rb$/)
  end
end
