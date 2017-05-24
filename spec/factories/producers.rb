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

  factory :producer_products, class: Producer, parent: :user do |f|
    f.first_name {Faker::Name.first_name}
    f.last_name {Faker::Name.last_name}

    transient do
      crops_count 5
    end

    f.after(:create) {|pp, eval|
      products = create_list(:product, 10)
      containers = create_list(:container, 10)
      crops = Array.new([])
      eval.crops_count.times do |i|
        crops.push(create(:crop, producer: pp, product: products.sample, container: containers.sample))
      end
      pp.crops << crops
    }
  end
end