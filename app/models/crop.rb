class Crop < ApplicationRecord
  belongs_to :container
  belongs_to :product
  belongs_to :producer

  validates_presence_of :sow_date
end
