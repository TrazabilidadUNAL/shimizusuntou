require 'rails_helper'

RSpec.describe Container, type: :model do
  # Ensure Container has column name present before saving
  it { should validate_presence_of(:name) }

  # Ensure Container has many Crops
  it { should have_many(:crops) }
end
