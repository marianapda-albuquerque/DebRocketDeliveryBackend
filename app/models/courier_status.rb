class CourierStatus < ApplicationRecord
    has_many :couriers
    enum :name, [ :free, :busy, :full, :offline ]
    validates_associated :couriers
    validates :name, presence: true
end
