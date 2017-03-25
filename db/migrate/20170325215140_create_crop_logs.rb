class CreateCropLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :crop_logs do |t|
      t.text :description
      t.references :crop, foreign_key: true

      t.timestamps
    end
  end
end
