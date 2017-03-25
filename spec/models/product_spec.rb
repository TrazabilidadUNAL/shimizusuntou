require 'rails_helper'

RSpec.describe Product, type: :model do
  # Ensure Product has column name present before saving
  it { should validate_presence_of(:name) }

  # Ensure Product has many Crops
  it { should have_many(:crops) }
end
