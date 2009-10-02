ActionController::Routing::Routes.draw do |map|
  map.resources :vurls, :except => :show, :member => {:real_time_clicks => :get, :redirect => :get}, :collection => {:random => :get}
  map.redirect  ':slug', :controller => 'vurls', :action => 'redirect'
  map.preview   '/p/:slug', :controller => 'vurls', :action => 'preview'
  map.stats     '/stats/:slug', :controller => 'vurls', :action => 'stats'

  map.root :controller => 'vurls', :action => 'new'
end
