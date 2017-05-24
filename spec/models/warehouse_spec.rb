require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  # Ensure Warehouse has name username and password
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:email) }

  # Ensure a Warehouse belongs to a Place
  it { should have_many(:places) }
end
