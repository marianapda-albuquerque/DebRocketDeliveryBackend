class Address < ApplicationRecord
    has_many :employees
    has_many :customers
    has_one :restaurant
    validates_associated :employees, :customers, :restaurant
end
