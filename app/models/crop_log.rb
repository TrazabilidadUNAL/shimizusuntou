class CropLog < ApplicationRecord
  belongs_to :crop

  validates_presence_of :description

  default_scope {order("crop_logs.created_at DESC")}
  scope :order_by_created_at, -> (date) {order("crop_logs.created_at #{date}")}

  def self.load(page = 1, per_page = 10)
    includes( crop: [:container, :product, :producer]).paginate(:page => page, :per_page => per_page)
  end

  def self.by_id(id)
    includes( crop: [:container, :product, :producer]).find_by({id: id})
  end

  def self.by_ids(ids, page = 1, per_page = 10)
    load(page, per_page).where(crop_logs:{id: ids})
  end

  def self.by_crop(crop_id, page = 1, per_page = 10)
    load(page, per_page).where(crops:{id: crop_id})
  end

  def self.search(query, sort = nil)
    if sort.present?
      s = sort[1,sort.size-1]
      if sort[0] == '-'
        where("description ILIKE ?", "%#{query}%").order(s+' DESC')
      else
        where("description ILIKE ?", "%#{query}%").order(s+' ASC')
      end
    else
      where("description ILIKE ?", "%#{query}%")
    end
  end

end
