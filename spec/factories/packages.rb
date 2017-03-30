FactoryGirl.define do
  factory :parent_package, :class => Package do
    parent_id 0
    crop { FactoryGirl.create(:crop) }
    route { FactoryGirl.create(:route)}
    quantity { Faker::Number.positive }
  end

  factory :package do
    # package { FactoryGirl.create(:package) }
    association :parent_id, factory: :parent_package
    crop { FactoryGirl.create(:crop) }
    route { FactoryGirl.create(:route)}
    quantity { Faker::Number.positive }

  end
end