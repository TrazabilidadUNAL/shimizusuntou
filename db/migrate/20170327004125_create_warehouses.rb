class CreateWarehouses < ActiveRecord::Migration[5.1]
  def change
    create_table :warehouses do |t|
      t.references :place, foreign_key: true
      t.string :name
      t.string :username
      t.string :password

      t.timestamps
    end
  end
end
