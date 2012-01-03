Barrelrun::Application.routes.draw do
  resources :registration_levels, 
                :as => :registrations,
                :only => [:index], 
                :member => {:apply => :get}

  resources :authentications

  devise_for :wineries #, :controller => "wineries/registrations"
  devise_for :users

  resources :wines do
    member do
      post :rating
    end
    collection do
      get :distinct_varietals
      get :distinct_wine_types
    end
  end
    
  resources :wineries do
    member do
      post :rating
    end
    resources :wines
    resources :comments
    resources :favorites
    resources :ratings
    resources :credit_cards
  end
                  
  resources :events do
    member do
      post :rating
    end
  end
  
  resources :specials do
    member do
      post :rating
    end
  end

  resources :favorites do
    collection do
      get :favorite_wines
      get :favorite_wineries
      get :favorite_events
      get :favorite_specials
    end
  end

  match 'favorites/:favorable_type/:favorable_id/rate', :to => 'favorites#rate_it'
  match 'auth/:provider/callback', :to => 'authentications#create'

  resources :awards
  resources :pictures
  resources :videos do
    collection do 
      get :index_yt
    end
  end
  resources :youtube_videos do
    collection do
      get :upload
      get :add_to_winery_details
      get :remove_from_winery_details
      get :make_primary
    end
  end
  resources :credit_cards
  resources :subscriptions do
    member do
      post :make_default
    end
  end
  resources :wines do
    resources :comments  
  end
  resources :users do
    resources :comments
    resources :wines, :only => [:index], :as => 'favorite_wines'
    resources :wineries, :only => [:index], :as => 'favorite_wineries'
    resources :events, :only => [:index], :as => 'favorite_events'
    resources :specials, :only => [:index], :as => 'favorite_specials'
    resources :users, :only => [:index], :as => 'favorite_users'
  end
  resources :events do
    resources :comments
  end
  resources :specials do
    resource :comments
  end
  resources :wines do
    resources :favorites
  end
#  resources :wineries, :has_many => :favorites  
  resources :users do
    resource :favorites
  end
  resources :events do
    resources :favorites  
  end
  resources :specials do
    resources :favorites
  end
  resources :specials do
    resources :ratings
  end
  resources :wines do
    resources :ratings
  end
#  resources :wineries, :has_many => :ratings
#  resources :wineries, :has_many => :credit_cards
  resources :events do
    resources :ratings
  end

  namespace :user do
  	resources :wineries do
      resources :wines
      member do
        get 'claim'
        put 'update_claim'
      end
  	end    
  end

  resources :emails do
    collection do
      post :incoming
    end
  end


######## MARKV: This controles where we go after the user logs in, change to HOME for user and ACCOUNT for client.
########  user_root '/home', :controller => 'home' # creates user_root_path
#####  
#####  # You can have the root of your site routed with root -- just remember to delete public/index.html.
  root :to => 'home#index'

  match 'top/:top/wines/:id/rating', :to => 'wines#rating'
  match 'wineries/:winery_id/wines/:id/rating', :to => 'wines#rating'
  match 'top/:top/specials/:id/rating', :to => 'specials#rating'
  match 'wineries/:winery_id/specials/:id/rating', :to =>'specials#rating'
  match 'top/:top/events/:id/rating', :to => 'events#rating'
  match 'wineries/:winery_id/events/:id/rating', :to => 'events#rating'

  match 'home/top_wines.:format', :to => 'home#top_wines'
  match 'home/top_wineries.:format', :to => 'home#top_wineries'
  match 'home/upcoming_events.:format', :to => 'home#upcoming_events'
  match 'home/upcoming_specials.:format', :to => 'home#upcoming_specials'
  match 'home/local_wineries.:format', :to => 'home#local_wineries'

  match 'searches/search(/:search)' => 'searches#search'
  match 'searches/faceted_search(/:search)' => 'searches#faceted_search'
#  match ':controller(/:action(/:id))'

end
