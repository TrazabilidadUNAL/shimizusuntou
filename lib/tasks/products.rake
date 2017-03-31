require 'faker'

namespace :db do
  namespace :seed do
    desc "Seeds up to 500 different products"
    task products: :environment do
      500.times do |index|
        Product.create!(
            name: Faker::Beer.name
        )
      end
      p "Created #{Product.count} products"
    end
  end
end