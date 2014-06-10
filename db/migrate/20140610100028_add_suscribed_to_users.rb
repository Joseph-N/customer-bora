class AddSuscribedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :suscribed, :boolean, :default => true
  end
end
