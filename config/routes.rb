ActionController::Routing::Routes.draw do |map|
  map.stats     '/stats/:slug', :controller => 'vurls', :action => 'stats'
  map.spam      '/spam/:slug', :controller => 'vurls', :action => 'spam'
  map.twitter   '/twitter', :controller => 'twitter', :action => 'index', :conditions => {:method => :get}
  map.shorten   '/shorten.:format', :controller => 'vurls', :action => 'api', :conditions => {:method => :get}
  map.resources :vurls, :except => :show,
    :member => {
      :description => :get,
      :flag_as_spam => :get,
      :real_time_clicks => :get,
      :redirect => :get,
      :screenshot => :get,
      :title => :get
  },
    :collection => {
      :random => :get,
      :chart_settings => :get,
      :image_screenshot => :get
  }
  map.resources :user_sessions, :only => [:create, :new]
  map.resource  :user, :only => [:edit, :update]
  map.redirect  ':slug', :controller => 'vurls', :action => 'redirect'
  map.preview   '/p/:slug', :controller => 'vurls', :action => 'preview'

  map.resources :pages, :collection => {:tweetie => :get}

  map.root :controller => 'vurls', :action => 'new'
end
