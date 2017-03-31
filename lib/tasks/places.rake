unless Rails.env.production?
  require 'faker'

  namespace :db do
    namespace :seed do
      desc "Seeds up to 500 different Places"
      task places: :environment do
        500.times do |index|
          Place.create!(
              tag: Faker::Address.street_name,
              lat: Faker::Address.latitude.to_f,
              lon: Faker::Address.longitude.to_f
          )
        end
        p "Created #{Place.count} places"
      end
    end
  end
end