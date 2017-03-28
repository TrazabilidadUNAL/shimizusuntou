class CreateRouteLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :route_logs do |t|
      t.references :route, foreign_key: true
      t.float :temperature
      t.float :humidity
      t.float :lat
      t.float :lon

      t.timestamps
    end
  end
end
