FactoryGirl.define do
  factory :producer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { Faker::Internet.user_name }
    password { Faker::Internet.password(8, 20) }
  end

  factory :producer_with_places, class: 'Producer' do |f|
    f.first_name { Faker::Name.first_name }
    f.last_name { Faker::Name.last_name }
    f.username { Faker::Internet.user_name }
    f.password { Faker::Internet.password(8, 20) }

    transient do
      places_count 5
    end

    f.after(:create) { |pwp, eval|
      pwp.places << create_list(:producer_place, eval.places_count, localizable: pwp)
    }
  end
end