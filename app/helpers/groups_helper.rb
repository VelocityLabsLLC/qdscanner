module GroupsHelper
  def user_role_display(user)
    if user.has_role?(:creator, @group)
      return "Creator"
    elsif user.has_role?(:admin, @group)
      return "Admin"
    elsif user.has_role?(:tech, @group)
      return "Tech"
    else
      return ""
    end
  end
end
