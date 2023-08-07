class AddSupplierToStocks < ActiveRecord::Migration[7.0]
  def change
    add_column :stocks, :supplier, :text
  end
end
