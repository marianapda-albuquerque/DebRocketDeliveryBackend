class Order < ApplicationRecord
  belongs_to :restaurant
  belongs_to :customer
  belongs_to :order_status
  belongs_to :courier
  has_many :product_orders
  validates_associated :product_orders
  validates :restaurant_rating, inclusion: { in: [1, 2, 3, 4, 5, nil]}
  validates :restaurant, :customer, :order_status, presence: true
end
