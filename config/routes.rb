Kidr::Application.routes.draw do
 
  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

  devise_for :users
  
  namespace :admin do
    resources :sites, :only => :index
    resources :users, :only => [:index, :edit, :update, :show, :destroy]
  end
  
  resources :sites, :except => [:show, :index] do
    resources :pages do
      resources :attachments
      resources :comments
      resources :archives
      member do
        put :reset
      end
      collection do
        post :reorder
      end
    end
    resources :events
      
    resources :documents do
      member do
        get :download
      end
    end
    resources :photos, :only => :index
    resources :messages, :only => [:index, :new, :create]
    resources :memberships do
      member do 
        put :invite
      end
      collection do 
        get :build_many
        post :create_many
      end
    end
    resources :log_entries, :only => :index
  end
  resources :feedbacks
  
  root :to => 'application#show'
  match "/about", :to => 'application#about', :as => :about
  match "/tour", :to => 'application#tour', :as => :tour
  
  # Finally - show a page...
  
  match "/:site_permalink(/:page_permalink)" => "pages#show", :as => :permalink

end
