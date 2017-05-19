FactoryGirl.define do
  factory :producer, class: Producer, parent: :user do
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
  end

  factory :producer_with_places, class: Producer, parent: :user do |f|
    f.first_name {Faker::Name.first_name}
    f.last_name {Faker::Name.last_name}

    transient do
      places_count 5
    end

    f.after(:create) {|pwp, eval|
      pwp.places << create_list(:producer_place, eval.places_count, localizable: pwp)
    }
  end
end