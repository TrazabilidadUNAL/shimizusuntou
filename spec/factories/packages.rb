FactoryGirl.define do
  factory :parent_package, :class => Package do
    parent_id nil
    crop { FactoryGirl.create(:crop) }
    route { FactoryGirl.create(:route)}
    quantity { Faker::Number.positive }
  end

  factory :package do
    crop { FactoryGirl.create(:crop) }
    route { FactoryGirl.create(:route)}
    quantity { Faker::Number.positive }

  end
end