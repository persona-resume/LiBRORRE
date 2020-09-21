module UsersHelper
  def same_user_or_admin?(user)
    if user_signed_in?
      if user == current_user
        true
      elsif current_user.admin == true
        true
      else
        false
      end
    else
      false
    end
  end

  def admin?
    if user_signed_in?
      if current_user.admin == true
        true
      else
        false
      end
    else
      false
    end
  end

end
