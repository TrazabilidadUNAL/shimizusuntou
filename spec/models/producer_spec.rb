require 'rails_helper'

RSpec.describe Producer, type: :model do
  # Ensure Producer has first_name last_name username and password
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password) }

  # Ensure a Producer belongs to a Place and has many Crops
  it { should belong_to(:place) }
  it { should have_many(:crops) }
end
