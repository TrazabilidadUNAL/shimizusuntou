require 'faker'

namespace :db do
  namespace :seed do
    desc "Seeds up to 500 different packages"
    task packages: :environment do
      crops = Crop.count
      routes = Route.count
      500.times do |index|
        p = Package.new(
            crop_id: Faker::Number.between(1, crops),
            route_id: Faker::Number.between(1, routes),
            quantity: Faker::Number.normal(5, 1.5)
        )
        packs = Package.count
        if Faker::Boolean.boolean(0.2) && packs > 10
          p.parent_id = Faker::Number.between(1, packs)
        end
        p.save!
      end
      p "Created #{Package.count} packages"
    end
  end
end
