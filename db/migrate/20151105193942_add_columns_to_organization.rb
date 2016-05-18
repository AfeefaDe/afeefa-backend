class AddColumnsToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :title, :string
    add_column :organizations, :description, :text
    add_column :organizations, :logo, :string
    add_column :organizations, :support_wanted, :boolean
    add_column :organizations, :api_access, :string
    add_column :organizations, :api_key, :string
  end
end
