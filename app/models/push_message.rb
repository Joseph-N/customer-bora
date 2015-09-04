class PushMessage < ActiveRecord::Base
  validates_presence_of :aftk_id, :message, :to, :from, :aftk_linkid, :sent_at
end
