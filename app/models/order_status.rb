class OrderStatus < ApplicationRecord
    has_many :orders
    validates_associated :orders
    validates :name, presence: true
    validates :name, inclusion: { in: ['pending', 'in progress', 'delivered']}
end
