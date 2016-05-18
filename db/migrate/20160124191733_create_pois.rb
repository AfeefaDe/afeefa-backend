class CreatePois < ActiveRecord::Migration
  def change
    create_table :pois do |t|
      # all entry data
      t.string :title
      t.string :description
      # image
      t.string :public_speaker
      t.string :location_type # way, point
      t.boolean :support_wanted
      t.datetime :activated_at
      t.datetime :deactivated_at

      t.timestamps null: false

      # poi specific data
    end
  end
end
