module UsersHelper
  def user_age(user)
    Date.today.year - user.birthday.year
  end
end
