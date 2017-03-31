require 'rails_helper'

RSpec.describe Package, type: :model do
  # Ensure package has quantity
  it { should validate_presence_of(:quantity) }

  # Ensures associations
  it { should belong_to(:parent) }
  it { should have_many(:packages) }
  it { should belong_to(:crop) }
  it { should belong_to(:route) }
end
