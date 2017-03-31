class Crop < ApplicationRecord
  belongs_to :container
  belongs_to :product
  belongs_to :producer

  has_many :crop_logs
  has_many :packages

  validates_presence_of :sow_date
end
