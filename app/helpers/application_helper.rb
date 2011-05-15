module ApplicationHelper
  def avatar_tag(user = @current_user)
    %Q(<img src="data:image/jpeg;base64,#{Base64.encode64(user.avatar.read)}" />)
  end

  def workflow_tag(invoice)
    haml_tag("div.workflow_state_#{invoice.current_state}", "#{t(invoice.current_state)}")
    invoice.current_state.events.each do |k,v|
      haml_tag("button.event_#{k}", "#{t(k)}")
    end
  end
end
