class Courier < ApplicationRecord
  belongs_to :user
  belongs_to :address
  belongs_to :courier_status
  has_many :orders
end
