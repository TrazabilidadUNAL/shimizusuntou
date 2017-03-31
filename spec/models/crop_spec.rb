require 'rails_helper'

RSpec.describe Crop, type: :model do
  # Ensure Crop has column sow_date and harvest_date
  it { should validate_presence_of(:sow_date) }

  # Ensure a Crop belongs to a Container, a Product and a Producer
  it { should belong_to(:container) }
  it { should belong_to(:product) }
  it { should belong_to(:producer) }

  # Ensure a Crop has many CropLogs
  it { should have_many(:crop_logs) }
  it { should have_many(:packages) }
end
