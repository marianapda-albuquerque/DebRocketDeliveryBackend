class Customer < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :orders
  validates_associated :orders
end
