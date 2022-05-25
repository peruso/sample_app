Rails.application.routes.draw do
  # get 'password_resets/new'
  # get 'password_resets/edit'
  # get 'users/new'
  #上を消したが問題はなさそう。下のsign upがあるから
  root 'static_pages#home'
  get  '/help', to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

 
  
  # 上を名前付きルートを使えるよう下のように変換 resources :usersがあれば大丈夫getなくてもよしのよう
  # get  '/show', to: 'users#show'
  # get 'users/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  resources :users
  # account_activations resourceのeditへのルーティングのみを生成
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
