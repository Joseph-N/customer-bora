class Submission < ActiveRecord::Base
  belongs_to :user
  has_many :aliases

  validates_presence_of :name, :serial_no
  validates_uniqueness_of :serial_no

  scope :groupped, -> { group(:user_id,:id) }
end
