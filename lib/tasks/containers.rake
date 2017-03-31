unless Rails.env.production?
  require 'faker'

  namespace :db do
    namespace :seed do
      desc "Seeds up to 500 different containers"
      task containers: :environment do
        500.times do |index|
          Container.create!(
              name: Faker::Beer.yeast
          )
        end
        p "Created #{Container.count} containers"
      end
    end
  end
end