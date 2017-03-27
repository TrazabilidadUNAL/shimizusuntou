FactoryGirl.define do
  factory :route do
    origin { FactoryGirl.create(:place) }
    destination { FactoryGirl.create(:place) }
  end
end