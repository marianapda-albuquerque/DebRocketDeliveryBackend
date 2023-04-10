class Order < ApplicationRecord
  belongs_to :restaurant
  belongs_to :customer
  belongs_to :order_status
  validates :restaurant_rating, inclusion: { in: [1, 2, 3, 4, 5, nil]}
end
