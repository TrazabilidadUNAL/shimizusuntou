class CreateProducers < ActiveRecord::Migration[5.1]
  def change
    create_table :producers do |t|
      t.references :place, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password

      t.timestamps
    end
  end
end
