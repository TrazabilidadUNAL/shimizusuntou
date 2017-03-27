class AddShowToWarehouses < ActiveRecord::Migration[5.1]
  def change
    add_column :warehouses, :show, :boolean, default: true
  end
end
