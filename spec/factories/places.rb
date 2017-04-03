FactoryGirl.define do
  factory :producer_place, class: 'Place' do
    tag { Faker::Address.street_name }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
    localizable { FactoryGirl.create(:producer) }
  end

  factory :warehouse_place, class: 'Place' do
    tag { Faker::Address.street_name }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
    localizable { FactoryGirl.create(:warehouse) }
  end
end