Rails.application.routes.draw do
  resources :shorteners, except: [:show]



  get '/:short_url', to: 'shorteners#show_link'
  get "shorteners/new_release", to: 'shorteners#new_release'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'shorteners#index'
end
