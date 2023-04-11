class Restaurant < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :products
  has_many :orders
  validates :price_range, inclusion: { in: [1, 2, 3]}
  validates_associated :products, :orders
  validates :user, :address, :phone, :name, :price_range, :active, presence: true
end
