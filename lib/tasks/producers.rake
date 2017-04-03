unless Rails.env.production?
  require 'faker'

  namespace :db do
    namespace :seed do
      desc "Seeds up to 500 different producers"
      task producers: :environment do
        500.times do |index|
          Producer.create!(
              first_name: Faker::Name.first_name,
              last_name: Faker::Name.last_name,
              username: Faker::Internet.user_name,
              password: Faker::Internet.password(8),
          )
        end
        p "Created #{Producer.count} producers"
      end
    end
  end
end