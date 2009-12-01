ActionController::Routing::Routes.draw do |map|
  map.shorten   '/shorten.:format', :controller => 'vurls', :action => 'api', :conditions => {:method => :get}
  map.resources :vurls, :except => :show, :member => {:real_time_clicks => :get, :redirect => :get}, :collection => {:random => :get, :chart_settings => :get}
  map.redirect  ':slug', :controller => 'vurls', :action => 'redirect'
  map.preview   '/p/:slug', :controller => 'vurls', :action => 'preview'
  map.stats     '/stats/:slug', :controller => 'vurls', :action => 'stats'

  map.root :controller => 'vurls', :action => 'new'
end
