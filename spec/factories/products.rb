FactoryGirl.define do
  factory :product do
    name { Faker::Beer.name }
  end
end