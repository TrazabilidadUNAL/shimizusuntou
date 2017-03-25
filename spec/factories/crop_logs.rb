FactoryGirl.define do
  factory :crop_log do
    description { Faker::StarWars.quote }
    crop { FactoryGirl.create(:crop) }
  end
end