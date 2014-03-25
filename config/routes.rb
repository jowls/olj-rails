Oljournal::Application.routes.draw do
  resources :days

  devise_for :users, :controllers => {:registrations => "registrations"}           #http://stackoverflow.com/questions/3546289/override-devise-registrations-controller
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'page#index'
  get 'about' => 'page#about'
  get 'inspiration' => 'page#inspiration'
  get 'poll' => 'page#poll'

  get 'journal', to: 'days#index'
  post 'welcome', to: 'page#begin_user_onboard'
  get 'finish', to: 'days#finish_user_onboard'
  post 'finish', to: 'days#finish_user_onboard'

  post 'gcm', to: 'page#send_gcm'

  namespace :api do
    namespace :v1 do
      resources :tokens,:only => [:create, :destroy]
      resources :mobiles
      post 'mobiles/addday', to: 'mobiles#addday'
      post 'mobiles/alldays', to: 'mobiles#alldays'
      post 'mobiles/editday', to: 'mobiles#editday'
      post 'mobiles/gcmregid', to: 'mobiles#gcmregid'
    end
  end
end
