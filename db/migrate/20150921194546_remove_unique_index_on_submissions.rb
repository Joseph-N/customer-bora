class RemoveUniqueIndexOnSubmissions < ActiveRecord::Migration
  def change
    remove_index :submissions, :serial_no
  end
end
