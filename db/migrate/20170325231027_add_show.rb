class AddShow < ActiveRecord::Migration[5.1]
  def change
    add_column :containers, :show, :boolean, default: true
    add_column :crops, :show, :boolean, default: true
    add_column :crop_logs, :show, :boolean, default: true
    add_column :places, :show, :boolean, default: true
    add_column :producers, :show, :boolean, default: true
    add_column :products, :show, :boolean, default: true
  end
end
