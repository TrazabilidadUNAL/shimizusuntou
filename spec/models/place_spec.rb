require 'rails_helper'

RSpec.describe Place, type: :model do
  # Ensure Place has columns tag, lat and lon present before saving
  it { should validate_presence_of(:tag) }
  it { should validate_presence_of(:lat) }
  it { should validate_presence_of(:lon) }

  # Ensure has many Producers
  it { should have_many(:producers) }
  it { should have_many(:origins) }
  it { should have_many(:destinations) }
end
