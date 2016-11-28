Rails.application.routes.draw do
  resources :shorteners do

  end
  get '/:short_url', to: 'shorteners#show_link'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'shorteners#index'
end
