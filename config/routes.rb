ActionController::Routing::Routes.draw do |map|
  map.resources :vurls, :member => {:redirect => :get, :clicks => :get}, :collection => {:random => :get}
  map.redirect  ':slug', :controller => 'vurls', :action => 'redirect'
  map.preview   '/p/:slug', :controller => 'vurls', :action => 'preview'
  map.stats     '/stats/:slug', :controller => 'vurls', :action => 'stats'

  map.root :controller => 'vurls', :action => 'new'
end
