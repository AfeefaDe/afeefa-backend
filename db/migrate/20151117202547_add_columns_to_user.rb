class AddColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :access_token, :string
    add_column :users, :forename, :string
    add_column :users, :surname, :string
    add_column :users, :gender, :integer
    add_column :users, :degree, :string
    add_column :users, :registered_at, :datetime
    add_column :users, :activated_at, :datetime
    add_column :users, :enabled_at, :datetime
  end
end
