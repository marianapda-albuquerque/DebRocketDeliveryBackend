class Product < ApplicationRecord
  belongs_to :restaurant
  validates :cost, inclusion: { minimum: 0}
end
