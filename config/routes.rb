Kidr::Application.routes.draw do
 
  match '/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

  devise_for :users
  
  namespace :admin do
    resources :sites, :only => :index
    resources :users, :only => [:index, :edit, :update, :show, :destroy]
  end
  
  resources :sites, :except => [:show, :index] do
    member do
      get :edit_top_story
      put :update_top_story
    end
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
    resources :memberships
    resources :invitations do
      member do 
        put :relay
      end
      collection do 
        get :new_many
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
  
  match "/:site_permalink" => "sites#show", :as => :site_root
  match "/:site_permalink(/:page_permalink)" => "pages#show", :as => :permalink

end
