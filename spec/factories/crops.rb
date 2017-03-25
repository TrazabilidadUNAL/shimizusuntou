FactoryGirl.define do
  factory :crop do
    sow_date { Faker::Date.backward(10) }
    container { FactoryGirl.create(:container) }
    product { FactoryGirl.create(:product) }
    producer { FactoryGirl.create(:producer) }
  end
end