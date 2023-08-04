class AddWarehouseToStocks < ActiveRecord::Migration[7.0]
  def change
    add_column :stocks, :warehouse, :string
  end
end
