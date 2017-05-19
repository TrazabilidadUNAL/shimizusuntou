module Localizable
  extend ActiveSupport::Concern

  included do
    has_many :places, -> {where(show: true)}, as: :localizable
  end
end
