class AddHashToPackages < ActiveRecord::Migration[5.1]
  def change
    add_column :packages, :qrhash, :string
    add_index :packages, :qrhash
  end
end
