class CreatePackages < ActiveRecord::Migration[5.1]
  def change
    create_table :packages do |t|
      t.references :parent, index: true
      t.references :crop, foreign_key: true
      t.references :route, foreign_key: true
      t.float :quantity

      t.timestamps
    end
  end
end
