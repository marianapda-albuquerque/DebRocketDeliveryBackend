class ProductOrder < ApplicationRecord
  belongs_to :product
  belongs_to :order
  validates :product_quantity, comparison: { greater_than_or_equal_to: 1 }
  validates :product_unit_cost, comparison: { greater_than_or_equal_to: 0 }
end
