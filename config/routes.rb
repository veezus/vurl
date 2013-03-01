VurlApp::Application.routes.draw do
  match "/spam/:slug", to: "vurls#spam", as: "spam"
  match ":slug", to: "vurls#redirect", as: 'redirect'
end
