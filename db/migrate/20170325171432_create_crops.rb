class CreateCrops < ActiveRecord::Migration[5.1]
  def change
    create_table :crops do |t|
      t.datetime :sow_date
      t.datetime :harvest_date
      t.references :container, foreign_key: true
      t.references :product, foreign_key: true
      t.references :producer, foreign_key: true

      t.timestamps
    end
  end
end
