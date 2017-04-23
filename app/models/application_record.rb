class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.exists?(id)
    if (super(id))
      self.find(id).show
    end
  end
end
