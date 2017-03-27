class AddShowToRoutes < ActiveRecord::Migration[5.1]
  def change
    add_column :routes, :show, :boolean, default: true
  end
end
