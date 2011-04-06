module ApplicationHelper
  def avatar_tag(user = @current_user)
    %Q(<img src="data:image/jpeg;base64,#{Base64.encode64(user.avatar.read)}" />)
  end
end
