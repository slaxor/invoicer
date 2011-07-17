module ApplicationHelper
  def avatar_tag(user = @current_user)
    %Q(<img src="data:image/jpeg;base64,#{Base64.encode64(user.avatar.read)}" />)
  end

  def workflow_tag(invoice)
    haml_tag("div.workflow_state_#{invoice.current_state}", t("invoicer.workflow.states.#{invoice.workflow_state}"))
    invoice.current_state.events.each do |k,v|
      haml_tag("button.event_#{k}", t("invoicer.workflow.events.#{k.to_s}"))
    end
  end

  def ie_tag(name=:body, attrs={}, &block)
    attrs.symbolize_keys!
    haml_concat("<!--[if lt IE 7]> #{ tag(name, add_class('ie6', attrs), true) } <![endif]-->".html_safe)
    haml_concat("<!--[if IE 7]>    #{ tag(name, add_class('ie7', attrs), true) } <![endif]-->".html_safe)
    haml_concat("<!--[if IE 8]>    #{ tag(name, add_class('ie8', attrs), true) } <![endif]-->".html_safe)
    haml_concat("<!--[if gt IE 8]><!-->".html_safe)
    haml_tag name, attrs do
      haml_concat("<!--<![endif]-->".html_safe)
      block.call
    end
  end

  def ie_html(attrs={}, &block)
    ie_tag(:html, attrs, &block)
  end

  def ie_body(attrs={}, &block)
    ie_tag(:body, attrs, &block)
  end

private

  def add_class(name, attrs)
    classes = attrs[:class] || ''
    classes.strip!
    classes = ' ' + classes if !classes.blank?
    classes = name + classes
    attrs.merge(:class => classes)
  end
end

