class Route < ApplicationRecord
  belongs_to :origin, class_name: 'Place'
  belongs_to :destination, class_name: 'Place'

  has_many :route_logs
  has_many :packages

  scope :q, ->(q) {where('origin_id ILIKE ? OR destination_id ILIKE ? AND show = true', "%#{q}%", "%#{q}%")}

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

end
