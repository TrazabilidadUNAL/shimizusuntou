unless Rails.env.production?
  require 'faker'

  namespace :db do
    namespace :seed do
      desc "Seeds up to 500 different Places"
      task places: :environment do
        producers = Producer.count
        producers.times do |index|
          p = Producer.find(id = index + 1)
          Place.create!(
              tag: Faker::Address.street_name,
              lat: Faker::Address.latitude.to_f,
              lon: Faker::Address.longitude.to_f,
              localizable: p
          )
        end

        warehouses = Warehouse.count
        warehouses.times do |index|
          w = Warehouse.find(id = index + 1)
          Place.create!(
              tag: Faker::Address.street_name,
              lat: Faker::Address.latitude.to_f,
              lon: Faker::Address.longitude.to_f,
              localizable: w
          )
        end
        p "Created #{Place.count} places"
      end
    end
  end
end