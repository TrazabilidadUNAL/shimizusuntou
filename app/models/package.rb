class Package < ApplicationRecord
  belongs_to :crop
  belongs_to :route
  belongs_to :parent, class_name: 'Package', optional: true
  has_many :packages, class_name: 'Package', foreign_key: :parent_id

  validates_presence_of :quantity

  scope :q, ->(q) {where('quantity ILIKE ? AND show = true', "%#{q}%")}

  def destroy
    @packages = Package.where(parent_id: self.id)
    @packages.each do |pack|
      pack.show = false
      pack.save!
    end
    self.show = false
    self.save!
  end

  def self.load(page = 1, per_page = 10)
    includes(:route, :crop, :parent, :packages).paginate(:page => page, :per_page => per_page)
  end

  def self.by_id(id)
    includes(:route, :crop, :parent, :packages).find_by({id: id})
  end

  def self.by_ids(ids, page = 1, per_page = 10)
    load(page, per_page).where(packages: {id: ids})
  end

  def self.by_routes(route_ids, page = 1, per_page = 10)
    load(page, per_page).where(routes: {id: route_ids})
  end

  def self.by_crops(crop_id, page = 1, per_page = 10)
    load(page, per_page).where(crops: {id: crop_id})
  end

  def self.by_parent(parent_id, page = 1, per_page = 10)
    load(page, per_page).where(packages: {parent_id: parent_id})
  end
end
