class ProductOrder < ApplicationRecord
  belongs_to :product
  belongs_to :order
  validates :product_quantity, comparison: { greater_than_or_equal_to: 1 }
  validates :product_unit_cost, comparison: { greater_than_or_equal_to: 0 }
  validates :product, :order, :product_quantity, :product_unit_cost, presence: true
  validates_uniqueness_of :product_id, scope: %i[order_id]
  validate :restaurant_is_the_same
  
  def restaurant_is_the_same
    if product.respond_to?(:restaurant) && order.respond_to?(:restaurant) && product.restaurant_id != order.restaurant_id
      errors.add(:product, "must belong to the same restaurant as the order")
    end
  end

end
