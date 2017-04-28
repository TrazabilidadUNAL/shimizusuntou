class Place < ApplicationRecord
  belongs_to :localizable, polymorphic: true
  has_many :origins, class_name: 'Route', foreign_key: :origin_id
  has_many :destinations, class_name: 'Route', foreign_key: :destination_id

  validates_presence_of :tag
  validates_presence_of :lat
  validates_presence_of :lon

  def localizable_type=(class_name)
    super(class_name.constantize.base_class.to_s)
  end

  def destroy
    update_attribute(:show, false)
  end

  default_scope {order("places.tag ASC")}
  scope :order_by_tag, -> (tag) {order("places.tag #{tag}")}

  def self.load(page = 1, per_page = 10)
    includes(:localizable, :origins, :destinations).paginate(:page => page, :per_page => per_page)
  end

  def self.by_id(id)
    includes(:localizable, :origins, :destinations).find_by({id: id})
  end

  def self.by_ids(ids, page = 1, per_page = 10)
    load(page, per_page).where(places: {id: ids})
  end

  def self.by_origins(origin_ids, page = 1, per_page = 10)
    load(page, per_page).where(places: {id: origin_ids})
  end

  def self.by_destinations(destination_ids, page = 1, per_page = 10)
    load(page, per_page).where(places: {id: destination_ids})
  end

  def self.by_localizable(id, type, page = 1, per_page = 10)
    load(page, per_page).where(places: {localizable_id: id, localizable_type: type})
  end

end
