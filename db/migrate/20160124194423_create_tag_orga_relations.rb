class CreateTagOrgaRelations < ActiveRecord::Migration
  def change
    create_table :tag_orga_relations do |t|

      t.references :organization, index: true
      t.references :tag, index: true

      t.timestamps null: false

    end
  end
end
