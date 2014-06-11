class Submission < ActiveRecord::Base
  belongs_to :user, counter_cache: true
  has_many :aliases

  validates_presence_of :name, :serial_no
  validates_uniqueness_of :serial_no
end
