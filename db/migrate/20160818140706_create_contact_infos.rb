class CreateContactInfos < ActiveRecord::Migration
  def change
    create_table :contact_infos do |t|
      t.string :contact_person
      t.string :phone
      t.string :mail
      t.string :website
      t.string :place_name
      t.string :street
      t.string :zip
      t.string :city
      t.string :district

      t.references :contactable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
