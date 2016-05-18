class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :lat
      t.string :lon

      t.string :osm_id

      t.string :scope
      t.string :order
      t.boolean :displayed

      t.integer :organization_id

      t.timestamps null: false
    end
  end
end
