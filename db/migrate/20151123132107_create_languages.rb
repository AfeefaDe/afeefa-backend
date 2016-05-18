class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :code
      t.boolean :rtl

      t.timestamps null: false
    end
  end
end
