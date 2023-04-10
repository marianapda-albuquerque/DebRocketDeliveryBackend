class AddCourierToOrders < ActiveRecord::Migration[7.0]
  def change
    add_reference :orders, :courier, null: true, foreign_key: true
  end
end
