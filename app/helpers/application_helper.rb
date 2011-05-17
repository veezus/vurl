# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def page_title
    current_vurl && !current_vurl.title.blank? ?  current_vurl.title : "The URL shortener by Veezus Kreist"
  end

  # Thanks to mojombo for his clippy swf
  # http://github.com/mojombo/clippy
  def clippy(text, bgcolor='#FFFFFF')
    html = <<-EOF.html_safe
    <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
            width="14"
            height="14" >
    <param name="movie" value="/flash/clippy.swf"/>
    <param name="allowScriptAccess" value="always" />
    <param name="quality" value="high" />
    <param name="scale" value="noscale" />
    <param NAME="FlashVars" value="text=#{text}">
    <param name="bgcolor" value="#{bgcolor}">
    <embed src="/flash/clippy.swf"
           width="14"
           height="14"
           name="clippy"
           quality="high"
           allowScriptAccess="always"
           type="application/x-shockwave-flash"
           pluginspage="http://www.macromedia.com/go/getflashplayer"
           FlashVars="text=#{text}"
           bgcolor="#{bgcolor}"
    />
    </object>
    EOF
    content_tag(:span, html, class: 'clippy')
  end

  def link_to_period period
    if period == current_period
      content_tag :span, period.titleize, class: 'selected_period period_link'
    else
      link_to period.titleize, "?period=#{period}", class: 'deselected_period period_link'
    end
  end

  def popular_period_links
    %w(week day hour).map {|period| period_link(period) if Click.since(period_ago(period)).any?}.compact.join(' | ').html_safe
  end

  def period_link period
    current_period == period ? period : link_to(period, root_path(period: period))
  end

  def tab_class_for(link_name)
    case link_name
    when 'Home'
      'active' if controller_name == 'vurls' && action_name == 'new'
    when 'History'
      'active' if controller_name == 'vurls' && action_name == 'index'
    when 'My Account'
      'active' if controller_name == 'users'
    end
  end

  def error_class_for(object, attr)
    'error' if object.errors.keys.include?(attr)
  end
end
