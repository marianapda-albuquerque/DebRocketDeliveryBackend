class CourierStatus < ApplicationRecord
    has_many :couriers
    enum :name, [ :free, :busy, :full, :offline ]
end
