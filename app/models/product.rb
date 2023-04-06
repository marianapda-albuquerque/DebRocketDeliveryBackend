class Product < ApplicationRecord
  belongs_to :restaurant
  validates :cost, comparison: { greater_than_or_equal_to: 0 }
end
