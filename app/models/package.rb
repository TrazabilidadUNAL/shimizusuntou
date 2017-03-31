class Package < ApplicationRecord
  belongs_to :crop
  belongs_to :route
  belongs_to :parent, class_name: 'Package', optional: true
  has_many :packages, class_name: 'Package', foreign_key: :parent_id

  validates_presence_of :quantity

  def destroy
    @packages = Package.where(parent_id: self.id)
    @packages.each do |pack|
      pack.show = false
      pack.save!
    end
    self.show = false
    self.save!
  end

end
