module VurlsHelper
  def default_keywords
    'shorten url vurl long tinyurl rubyurl is.gd bit.ly ruby rails veez veezus kreist'
  end

  def default_description
    'Vurl shortens your long URLs - an app by Veezus Kreist'
  end

  def display_stats_link?
    !(controller_name == 'vurls' && action_name == 'stats')
  end
end
