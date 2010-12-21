Kidr::Application.routes.draw do
 
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
    resources :documents do
      member do
        get :download
      end
    end
    resources :photos, :only => :index
    resources :messages
    resources :memberships
    resources :log_entries, :only => :index
  end
  resources :feedbacks
  
  root :to => 'application#show'
  match "/about-us", :to => 'application#about_us', :as => :about_us
  match "/walkthrough", :to => 'application#walkthrough', :as => :walkthrough
  
  # Finally - show a page...
  
  match "/:site_permalink(/:page_permalink)" => "pages#show", :as => :permalink

end
