FactoryGirl.define do
  factory :warehouse do
    place_id { FactoryGirl.create(:place).id }
    name { Faker::Name.name }
    username { Faker::Internet.user_name }
    password { Faker::Internet.password(8, 20) }
  end
end