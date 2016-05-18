class CreateTagThingRelations < ActiveRecord::Migration
  def change
    create_table :tag_thing_relations do |t|

      t.references :tagable, polymorphic: true, index: true
      t.references :tag, index: true

      t.timestamps null: false
    end
  end
end
