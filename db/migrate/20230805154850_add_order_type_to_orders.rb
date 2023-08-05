class AddOrderTypeToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :orderType, :string
  end
end
