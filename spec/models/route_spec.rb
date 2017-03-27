require 'rails_helper'

RSpec.describe Route, type: :model do
  # Ensure Route has relations to Places for both Origin and Destination

  it { should belong_to(:origin) }
  it { should belong_to(:destination) }
end
