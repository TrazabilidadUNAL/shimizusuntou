class PlacesAsPolymorphicAssociation < ActiveRecord::Migration[5.1]
  def change
    change_table :places do |t|
      t.references :localizable, polymorphic: true
    end

    remove_reference :producers, :place
    remove_reference :warehouses, :place
  end
end
