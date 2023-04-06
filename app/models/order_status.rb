class OrderStatus < ApplicationRecord
    has_many :orders
    validates_associated :orders
end
