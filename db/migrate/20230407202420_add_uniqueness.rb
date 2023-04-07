class AddUniqueness < ActiveRecord::Migration[7.0]
  def change
    remove_index :employees, :user_id
    add_index :employees, :user_id, unique: true
    remove_index :customers, :user_id
    add_index :customers, :user_id, unique: true
  end
end
