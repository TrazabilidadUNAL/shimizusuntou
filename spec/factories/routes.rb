FactoryGirl.define do
  factory :route do
    origin { FactoryGirl.create(:producer_place) }
    destination { FactoryGirl.create(:warehouse_place) }
  end
end