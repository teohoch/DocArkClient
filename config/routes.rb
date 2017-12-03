Rails.application.routes.draw do
  get 'login', :to => 'session#login', :as => :new_session
  post 'authorize', :to => 'session#authorize', :as => :authorize
  get 'callback', :to => 'session#callback', :as => :oauth_callback


  delete 'session/logout', :as => :destroy_session

  resources :folders

  resources :files, controller: 'documents', as: 'documents' do
    get 'upgrade', on: :member
  end

  root to: 'session#login'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
