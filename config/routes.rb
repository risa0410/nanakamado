Rails.application.routes.draw do

  devise_for :users
  root to: 'homes#top'

  resources :users, only: [:show, :edit, :update, :index] do
    get 'users/favorite' => 'users#favorite'
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  get 'posts/hashtag/:name' => 'posts#hashtag'
  resources :posts do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end

  resources :notifications, only: :index

end
