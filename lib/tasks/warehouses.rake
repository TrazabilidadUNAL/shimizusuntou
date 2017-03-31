require 'faker'

namespace :db do
  namespace :seed do
    desc "Seeds up to 500 different warehouses"
    task warehouses: :environment do
      places = Place.count
      places.times do |index|
        Warehouse.create!(
            name: Faker::Company.name,
            username: Faker::Internet.user_name,
            password: Faker::Internet.password(8),
            place_id: Faker::Number.between(1, places)
        )
      end
      p "Created #{Warehouse.count} warehouses"
    end
  end
end