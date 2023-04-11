class Courier < ApplicationRecord
  belongs_to :user
  belongs_to :address
  belongs_to :courier_status
  has_many :orders
  validates_associated :orders
  validates :user, :address, :courier_status, :phone, :active, presence: true
end
