class CreatePlaces < ActiveRecord::Migration[5.1]
  def change
    create_table :places do |t|
      t.string :tag
      t.float :lat
      t.float :lon

      t.timestamps
    end
  end
end
