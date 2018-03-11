Rails.application.routes.draw do
  devise_for :users, :sign_out_via => [ :get, :delete ]
  resources :authors
  resources :books
  get 'users/index', to: 'users#index', as: :user_index
  get 'users/profile/:id/', to: 'users#profile', as: :user_profile
  get 'users/profile/:id/list', to:'users#list', as: 'list'
  get 'users/profile/edit_list/:id_user_book/', to: 'users#details', as: :list_book_details
  patch 'users/profile/edit_list/:id_user_book/', to:'users#update_list', as: 'book_update_list_adv'
  get 'users/profile/edit_list/:id_user_book/remove', to:'users#remove_list', as: 'remove_list'
  post 'books/user_list/:id/', to:'books#add_to_list', as: :book_add_list
  patch 'books/user_list/:id/', to:'books#update_list', as: :book_update_list
  get 'books/delete/:id', to: 'books#destroy', as: 'book_delete'
  get 'author/delete/:id', to: 'authors#destroy', as: 'author_delete'
  get 'search_results', to: 'search#search', as: 'search'
  get 'myreviews/new/:book_id', to: 'reviews#new', as: 'review_new'
  post 'myreviews/new/:book_id/create', to: 'reviews#create', as: 'review_create'
  get 'myreviews/:review_id/edit', to: 'reviews#edit', as: 'review_edit'
  patch 'myreviews/:review_id/edit', to: 'reviews#update', as: 'review_update'
  get 'myreviews/:review_id/delete', to: 'reviews#destroy', as: 'review_delete'
  get 'myreviews/:review_id/like', to: 'reviews#like', as: 'review_like'
  get 'myreviews/:review_id/dislike', to: 'reviews#dislike', as: 'review_dislike'

  root 'books#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
