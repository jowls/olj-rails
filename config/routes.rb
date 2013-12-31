Oljournal::Application.routes.draw do
  resources :days

  #devise_for :users
  # app/config/routes.rb
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
  namespace :api do
    namespace :v1 do
      resources :tokens,:only => [:create, :destroy]
      resources :mobiles
      post 'mobiles/addday', to: 'mobiles#addday'
      post 'mobiles/alldays', to: 'mobiles#alldays'
      post 'mobiles/editday', to: 'mobiles#editday'
    end
  end

  #get 'welcome' => 'page#begin_user_onboard'
  #post 'page#begin_user_onboard'
  #get '/days', to: redirect('journal')

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
