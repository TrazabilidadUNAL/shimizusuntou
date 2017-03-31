unless Rails.env.production?
  require 'faker'

  namespace :db do
    namespace :seed do
      desc 'Seeds up to 500 different crops and logs'
      task crops: :environment do
        containers = Container.count
        products = Product.count
        producers = Producer.count

        500.times do |index|
          c = Crop.new(
              sow_date: Faker::Date.between(Faker::Date.backward(100), Faker::Date.forward(100)),
              container_id: Faker::Number.between(1, containers),
              product_id: Faker::Number.between(1, products),
              producer_id: Faker::Number.between(1, producers)
          )
          if Faker::Boolean.boolean(0.5)
            c.harvest_date = Faker::Date.between(Faker::Date.backward(100), Faker::Date.forward(100))
          end
          c.save!

          3.times do |jindex|
            CropLog.create!(
                crop_id: c.id,
                description: Faker::Lorem.sentence
            )
          end
        end
        p "Created #{Crop.count} crops"
        p "Created #{CropLog.count} crop logs"
      end
    end
  end
end