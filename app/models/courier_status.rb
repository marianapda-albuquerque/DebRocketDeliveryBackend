class CourierStatus < ApplicationRecord
    enum :name, [ :free, :busy, :full, :offline ]
end
