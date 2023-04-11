class Employee < ApplicationRecord
  belongs_to :user
  belongs_to :address
  validates :user, :address, :phone, presence: true
end
