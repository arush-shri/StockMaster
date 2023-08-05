class AddDeliCountToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :deliCount, :integer
  end
end
