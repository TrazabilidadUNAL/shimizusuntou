FactoryGirl.define do
  factory :route_log do
    route {FactoryGirl.create(:route)}
    temperature { Faker::Number.between(0.0, 100.0) }
    humidity { Faker::Number.between(0.0, 100.0)  }
    lat { Faker::Address.latitude }
    lon { Faker::Address.longitude }
  end
end