module Localizable
  extend ActiveSupport::Concern

  included do
    has_many :places, as: :localizable
  end
end