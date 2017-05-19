require 'rails_helper'

RSpec.describe User, type: :model do
  # Ensure User has all fields
  it {should validate_presence_of(:username)}
  it {should validate_presence_of(:password)}
end
