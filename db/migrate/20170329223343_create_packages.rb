class CreatePackages < ActiveRecord::Migration[5.1]
  def change
    create_table :packages do |t|
      t.integer :parent_id, index: true
      t.references :crop, foreign_key: true
      t.references :route, foreign_key: true
      t.float :quantity

      t.timestamps
    end

    add_column :packages, :show, :boolean, default: true
    add_foreign_key :packages, :packages, column: :parent_id, primary_key: :id

  end
end
