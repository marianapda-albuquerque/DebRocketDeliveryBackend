class ProductOrder < ApplicationRecord
  belongs_to :product
  belongs_to :order
  validates :product_quantity, inclusion: { minimum: 1}
  validates :product_unit_cost, inclusion: { minimum: 0}
end
