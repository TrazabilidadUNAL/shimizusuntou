FactoryGirl.define do
  factory :container do
    name { Faker::StarWars.vehicle }
  end
end