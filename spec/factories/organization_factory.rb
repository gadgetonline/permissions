# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    name { Faker::Lorem.words(3).join }
  end
end
