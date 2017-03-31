require 'faker'

namespace :db do
  namespace :seed do
    desc 'Seeds up to 500 different routes and logs'
    task routes: :environment do
      places = Place.count
      places.times do |index|
        r = Route.create!(
            origin_id: Faker::Number.between(1, places),
            destination_id: Faker::Number.between(1, places)
        )
        3.times do |jindex|
          RouteLog.create!(
              route_id: r.id,
              temperature: Faker::Number.normal(20, 8),
              humidity: Faker::Number.normal(50, 8),
              lat: Faker::Address.latitude.to_f,
              lon: Faker::Address.longitude.to_f
          )
        end
      end
      p "Created #{Route.count} routes"
      p "Created #{RouteLog.count} route logs"
    end
  end
end