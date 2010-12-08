ActionController::Routing::Routes.draw do |map|
#  map.resources :ratings


  map.devise_for :wineries
  map.devise_for :users

  map.resources :wines
  map.resources :events
  map.resources :specials
  map.resources :favorites
  map.resources :awards
  map.resources :pictures
  map.resources :videos
  

  #MV: Added for Unobtrusive Destroy Link
  # map.resources :wines, :member => { :delete => :get }
  
  #MV: Added for Star Rating System
  map.resources :wines, :member => {:rate => :post, :rating => :post}
  map.resources :wineries, :member => {:rate => :post, :rating => :post}
  map.resources :events, :member => {:rate => :post, :rating => :post}
  map.resources :specials, :member => {:rate => :post, :rating => :post}

  
  #MV: Added for adding comments
  map.resources :wines, :has_many => :comments  
  map.resources :wineries, :has_many => :comments  
  map.resources :users, :has_many => :comments  
  map.resources :events, :has_many => :comments  
  map.resources :specials, :has_many => :comments  
  
  #MV: Added for adding favorites
  map.resources :wines, :has_many => :favorites
  map.resources :wineries, :has_many => :favorites  
  map.resources :users, :has_many => :favorites  
  map.resources :events, :has_many => :favorites  
  map.resources :specials, :has_many => :favorites
    
  map.resources :specials, :has_many => :ratings
  map.resources :wines, :has_many => :ratings
  map.resources :wineries, :has_many => :ratings
  map.resources :events, :has_many => :ratings


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

### MARKV: This controles where we go after the user logs in, change to HOME for user and ACCOUNT for client.
###  map.user_root '/home', :controller => 'home' # creates user_root_path
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.root :controller => 'home'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  
  map.connect 'home/top_wines', :action=>'top_wines',:controller=>'home'
  map.connect 'home/top_wineries', :action=>'top_wineries',:controller=>'home'
  map.connect 'home/upcoming_events', :action=>'upcoming_events',:controller=>'home'
  map.connect 'home/upcoming_specials', :action=>'upcoming_specials',:controller=>'home'
  map.connect 'home/local_wineries.:format', :action=>'local_wineries',:controller=>'home'
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
