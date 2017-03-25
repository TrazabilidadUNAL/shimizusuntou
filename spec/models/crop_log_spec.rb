require 'rails_helper'

RSpec.describe CropLog, type: :model do
  # Ensure CropLog has column description
  it { should validate_presence_of(:description) }

  # Ensures CropLog belongs to a Crop
  it { should belong_to(:crop) }
end
