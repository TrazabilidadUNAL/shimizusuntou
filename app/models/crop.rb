class Crop < ApplicationRecord

  default_scope {order("crops.created_at DESC")}
  scope :order_by_created_at, -> (date) {order("crops.created_at #{date}")}

  belongs_to :container
  belongs_to :product
  belongs_to :producer

  has_many :crop_logs
  has_many :packages

  validates_presence_of :sow_date
end
