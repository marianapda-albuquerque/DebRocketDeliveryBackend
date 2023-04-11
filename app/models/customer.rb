class Customer < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :orders
  validates_associated :orders
  validates :user, :address, :phone, :active, presence: true
end
