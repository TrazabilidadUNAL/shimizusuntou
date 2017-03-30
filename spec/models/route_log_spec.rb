require 'rails_helper'

RSpec.describe RouteLog, type: :model do
  # Ensure RouteLog has temperature humidity lat and lon
  it { should validate_presence_of(:temperature) }
  it { should validate_presence_of(:humidity) }
  it { should validate_presence_of(:lat) }
  it { should validate_presence_of(:lon) }

  # Ensure a RouteLog belongs to a Route
  it { should belong_to(:route)}
end
