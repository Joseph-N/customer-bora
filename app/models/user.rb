class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # validates_presence_of :name, :birthday, :location, :phone
  # validates_presence_of :phone
  validates_uniqueness_of :phone

  has_many :submissions
end
