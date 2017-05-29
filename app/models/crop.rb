class Crop < ApplicationRecord

  belongs_to :container
  belongs_to :product
  belongs_to :producer

  has_many :crop_logs, -> {where show: true}
  has_many :packages

  validates_presence_of :sow_date

  default_scope {order("crops.created_at DESC")}
  scope :order_by_created_at, -> (date) {order("crops.created_at #{date}")}

  def self.load(page = 1, per_page = 10)
    includes(:container, :product, :producer, :crop_logs, packages: [:route, :parent]).paginate(:page => page, :per_page => per_page)
  end

  def self.by_id(id)
    includes(:container, :product, :producer, :crop_logs, packages: [:route, :parent]).find_by({id: id})
  end

  def self.by_ids(ids, page = 1, per_page = 10)
    load(page, per_page).where(crops: {id: ids})
  end

  def self.by_producer(producer_id, page = 1, per_page = 10)
    load(page, per_page).where(producers: {id: producer_id})
  end

  def self.by_product(product_id, page = 1, per_page = 10)
    load(page, per_page).where(products: {id: product_id})
  end

  def self.by_container(container_id, page = 1, per_page = 10)
    load(page, per_page).where(containers: {id: container_id})
  end

end
