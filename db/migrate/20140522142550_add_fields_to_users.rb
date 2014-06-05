class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :birthday, :date
    add_column :users, :location, :string
    add_column :users, :phone, :string

    add_index :users, :phone, :unique => true
  end
end
