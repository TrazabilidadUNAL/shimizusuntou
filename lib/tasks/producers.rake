require 'faker'

namespace :db do
  namespace :seed do
    desc "Seeds up to 500 different producers"
    task producers: :environment do
      places = Place.count
      places.times do |index|
        Producer.create!(
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            username: Faker::Internet.user_name,
            password: Faker::Internet.password(8),
            place_id: Faker::Number.between(1, places)
        )
      end
      p "Created #{Producer.count} producers"
    end
  end
end