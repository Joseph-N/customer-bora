class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # validates_presence_of :name, :birthday, :location, :phone
  # validates_presence_of :phone
  validates :phone, uniqueness: true, presence: true, format: { with: /\A([0-9\(\)\/\+ \-]*)\z/,  message: "Invalid phone number" }

  has_many :submissions
end

