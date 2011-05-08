VurlApp::Application.routes.draw do
  match "/stats/:slug", to: "vurls#stats", as: "stats"
  match "/spam/:slug", to: "vurls#spam", as: "spam"
  match "/twitter", to: "twitter#index", as: "twitter"
  match "/shorten.:format", to: "vurls#api", as: "shorten"

  resources :pages do
    collection { get :tweetie }
  end
  resources :vurls, except: :show do
    member do
      get :description
      get :flag_as_spam
      get :real_time_clicks
      get :redirect
      get :screenshot
      get :title
    end
    collection do
      get :random
      get :chart_settings
      get :image_screenshot
    end
  end
  resource  :user, only: [:edit, :update]
  resources :user_sessions, only: [:create, :new]

  match ":slug", to: "vurls#redirect", as: 'redirect'

  root to: "vurls#new"
end
