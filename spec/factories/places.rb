FactoryGirl.define do
  factory :place do
    tag { Faker::Address.street_name }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end
end