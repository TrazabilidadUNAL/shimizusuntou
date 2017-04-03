FactoryGirl.define do
  factory :warehouse do
    name { Faker::Name.name }
    username { Faker::Internet.user_name }
    password { Faker::Internet.password(8, 20) }
  end

  factory :warehouse_with_place, class: 'Warehouse' do |f|
    f.name { Faker::Name.name }
    f.username { Faker::Internet.user_name }
    f.password { Faker::Internet.password(8, 20) }

    transient do
      places_count 5
    end

    f.after(:create) { |wwp, eval|
      wwp.places << create_list(:warehouse_place, eval.places_count, localizable: wwp)
    }
  end
end