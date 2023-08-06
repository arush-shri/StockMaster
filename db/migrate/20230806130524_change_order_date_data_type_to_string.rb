class ChangeOrderDateDataTypeToString < ActiveRecord::Migration[7.0]
  def change
    change_column :orders, :order_date, :string
  end
end
