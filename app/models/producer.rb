class Producer < ApplicationRecord

  default_scope {order("producers.first_name ASC")}
  scope :order_by_first_name, -> (type) {order("producers.first_name #{type}")}

  belongs_to :place
  has_many :crops

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :username
  validates_presence_of :password

  def self.load_producers(page = 1, per_page = 10)
    includes( :place, crops:[:container, :product, :producer] ).paginate(:page => page, :per_page => per_page)
  end

  def self.producers_by_id(id)
    includes( :place, crops:[:container, :product, :producer] ).find_by_id(id)
  end

  def self.producers_by_ids(ids, page = 1, per_page = 10)
    load_producers(page, per_page).where(producers:{id: ids})
  end

  def self.producers_by_not_ids(ids, page = 1, per_page = 10)
    load_producers(page, per_page).where.not(producers:{id: ids})
  end

  def self.producers_by_place(place, page = 1, per_page = 10)
    load_producers(page, per_page).where(producers:{place_id: place})
  end

end
