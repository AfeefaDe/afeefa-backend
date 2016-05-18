class CreateMarketEntries < ActiveRecord::Migration
  def change
    create_table :market_entries do |t|
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

      # market_entry specific data
      t.string :type # time, material
      t.string :way # offer, request
      t.string :availabilty
      t.datetime :requested_at
      t.datetime :assigned_at
      t.datetime :pending_since

      t.integer :creator_id
      t.integer :location_id
    end
  end
end
