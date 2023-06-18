class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :order_number
      t.integer :stock_id
      t.integer :quantity
      t.integer :user_id
      t.date :order_date
      t.string :status
      t.decimal :total_amount

      t.timestamps
    end
    add_foreign_key :orders, :users
    add_foreign_key :orders, :stocks
  end
end
