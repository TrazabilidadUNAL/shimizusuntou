FactoryGirl.define do
  factory :warehouse, class: Warehouse, parent: :user do
    name {Faker::Name.name}
  end

  factory :warehouse_with_place, class: Warehouse, parent: :user do |f|
    f.name {Faker::Name.name}

    transient do
      places_count 5
    end

    f.after(:create) {|wwp, eval|
      wwp.places << create_list(:warehouse_place, eval.places_count, localizable: wwp)
    }
  end
end