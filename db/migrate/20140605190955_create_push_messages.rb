class CreatePushMessages < ActiveRecord::Migration
  def change
    create_table :push_messages do |t|
      t.integer :aftk_id
      t.string :message
      t.string :from
      t.string :to
      t.string :aftk_linkid
      t.datetime :sent_at
    end
  end
end
