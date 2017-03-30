class AddShowToPackages < ActiveRecord::Migration[5.1]
  def change
    add_column :packages, :show, :boolean, default: true
  end
end
