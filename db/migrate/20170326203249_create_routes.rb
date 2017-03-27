class CreateRoutes < ActiveRecord::Migration[5.1]
  def change
    create_table :routes do |t|
      t.integer :origin_id
      t.integer :destination_id

      t.timestamps
    end
  end
end
