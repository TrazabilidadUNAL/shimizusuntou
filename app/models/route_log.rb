class RouteLog < ApplicationRecord
  belongs_to :route

  validates_presence_of :temperature
  validates_presence_of :humidity
  validates_presence_of :lat
  validates_presence_of :lon

  default_scope {order("route_logs.created_at DESC")}
  scope :order_by_created_at, -> (date) {order("route_logs.created_at #{date}")}

  def self.load(page = 1, per_page = 10)
    includes( :route).paginate(:page => page, :per_page => per_page)
  end

  def self.by_id(id)
    includes( :route).find_by({id: id})
  end

  def self.by_ids(ids, page = 1, per_page = 10)
    load(page, per_page).where(routes:{id: ids})
  end

  def self.by_route(route_id, page = 1, per_page = 10)
    load(page, per_page).where(routes:{id: route_id})
  end

end
