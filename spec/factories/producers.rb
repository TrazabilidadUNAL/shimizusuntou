FactoryGirl.define do
  factory :producer do
    place_id { FactoryGirl.create(:place).id }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { Faker::Internet.user_name }
    password { Faker::Internet.password(8, 20) }
  end
end