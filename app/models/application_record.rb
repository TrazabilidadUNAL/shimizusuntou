class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.exists?(id)
    if (super(id))
      self.find(id, true).show
    end
  end

  def self.find(ids, original = false)
    if original
      super(ids)
    else
      self.exists?(ids) ? self.find(ids, true) : nil
    end
  end

  def destroy
    update_attribute(:show, false)
  end

end
