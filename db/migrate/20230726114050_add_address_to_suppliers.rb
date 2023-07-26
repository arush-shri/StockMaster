class AddAddressToSuppliers < ActiveRecord::Migration[7.0]
  def change
    add_column :suppliers, :address, :string
  end
end
