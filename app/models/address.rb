class Address < ApplicationRecord
    has_many :employees
    has_many :customers
    has_many :couriers
    has_one :restaurant
    validates_associated :employees, :customers, :restaurant
    validates :street_address, :city, :postal_code, presence: true
end
