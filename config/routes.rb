Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: {format: :json} do
     namespace :v1 do
       resources :registrations, :only => [:create]
       resources :sessions, :only => [:create, :destroy]
       #resources :profiles, :only => [:create, :update] do
        # collection do
        #   patch :update_img
        #   patch :set_online
        #   patch :set_offline
        #   patch :update_location
        #   post :distance
         #end
       #end
     end
  end
end
