class AddCounterCacheToUsers < ActiveRecord::Migration
  def change
    add_column :users, :submissions_count, :integer, default: 0
    add_index  :users, :submissions_count
  end
end
