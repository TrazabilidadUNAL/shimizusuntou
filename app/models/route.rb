class Route < ApplicationRecord
  belongs_to :origin, class_name: 'Place'
  belongs_to :destination, class_name: 'Place'

  has_many :route_logs
  has_many :packages

  default_scope {order("routes.created_at DESC")}
  scope :order_by_created_at, -> (date) {order("routes.created_at #{date}")}

  def self.load(page = 1, per_page = 10)
    includes( :origin, :destination, :route_logs, packages:[:parent, :crop]).paginate(:page => page, :per_page => per_page)
  end

  def self.by_id(id)
    includes( :origin, :destination, :route_logs, packages:[:parent, :crop]).find_by({id: id})
  end

  def self.by_ids(ids, page = 1, per_page = 10)
    load(page, per_page).where(routes:{id: ids})
  end

  def self.by_origin(origin_id, page = 1, per_page = 10)
    load(page, per_page).where(routes:{origin_id: origin_id})
  end

  def self.by_destination(destination_id, page = 1, per_page = 10)
    load(page, per_page).where(routes:{destination_id: destination_id})
  end

  def self.search(query)
    #Route.where("created_at ILIKE ?", "%#{query}%")
    Route.where("created_at %#{query}%")
  end

end
