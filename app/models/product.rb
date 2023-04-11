class Product < ApplicationRecord
  belongs_to :restaurant
  has_many :product_orders
  validates_associated :product_orders
  validates :cost, comparison: { greater_than_or_equal_to: 0 }
  validates :restaurant, :name, :cost, presence: true
end
