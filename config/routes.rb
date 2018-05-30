Rails.application.routes.draw do


  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :sign_out_via => [ :get, :delete ]
  resources :authors
  resources :books

  get 'conversations', to: 'conversations#index', as: 'conversations'
  get 'conversation/get_chat/:conversation_id', to: 'messages#get_conversation', as: 'get_conversation'
  get 'conversations/new/:sender_id/:receiver_id', to: 'conversations#create', as: 'create_conversation'
  post 'conversations/new/:sender_id/:receiver_id', to: 'conversations#create', as: 'new_conversation'
  get 'conversation/conv=:conversation_id', to: 'messages#index', as: 'conversation_messages'
  post 'conversation/new/:conversation_id', to: 'messages#create', as: 'conversation_messages_create'
  get 'users/index', to: 'users#index', as: 'user_index'
  get 'users/profile/:id/', to: 'users#profile', as: 'user_profile'
  get 'users/profile/:id/reviews/', to: 'users#reviews', as: 'user_reviews'
  get 'users/profile/:id/friends/', to: 'users#friends', as: 'user_friends'
  get 'user/profile/:id/forum', to: 'users#forum', as: 'user_forum'
  get 'user/profile/:id/recommandations', to: 'users#recommandations', as: 'user_recs'
  post 'user/profile/:id/comments/new', to:'comments#comment_new_user', as: 'comment_new_user'
  get 'users/profile/:id/list', to:'users#list', as: 'list'
  get 'users/profile/edit_list/:id_user_book/', to: 'users#details', as: 'list_book_details'
  patch 'users/profile/edit_list/:id_user_book/', to:'users#update_list', as: 'book_update_list_adv'
  get 'users/profile/edit_list/:id_user_book/remove', to:'users#remove_list', as: 'remove_list'
  post 'books/user_list/:id/', to:'books#add_to_list', as: 'book_add_list'
  patch 'books/user_list/:id/', to:'books#update_list', as: 'book_update_list'
  post 'book/:id/comments/new', to:'comments#comment_new_book', as: 'comment_new_book'
  get 'author/delete/:id', to: 'authors#destroy', as: 'author_delete'
  post 'author/:id/comments/new', to:'comments#comment_new_author', as: 'comment_new_author'
  get 'search_results', to: 'search#search', as: 'search'
  get 'myreviews/new/:book_id', to: 'reviews#new', as: 'review_new'
  post 'myreviews/new/:book_id/create', to: 'reviews#create', as: 'review_create'
  get 'myreviews/:review_id/edit', to: 'reviews#edit', as: 'review_edit'
  patch 'myreviews/:review_id/edit', to: 'reviews#update', as: 'review_update'
  get 'myreviews/:review_id/delete', to: 'reviews#destroy', as: 'review_delete'
  get 'myreviews/:review_id/like', to: 'reviews#like', as: 'review_like'
  get 'myreviews/:review_id/dislike', to: 'reviews#dislike', as: 'review_dislike'
  get 'books/reviews/:id', to: 'books#reviews', as: 'book_reviews'
  get 'books/editions/:id', to: 'books#editions', as: 'book_editions'
  get 'books/recommandations/:id', to: 'books#recommandations', as: 'book_recommandations'
  get 'books/stats/:id', to: 'books#stats', as: 'book_stats'
  delete 'books/delete/:id', to: 'books#destroy', as: 'book_delete'
  get 'books/delete/:id' => 'books#destroy'
  get 'book/:book_id/editions/new/', to: 'editions#new', as: 'edition_new'
  post 'book/:book_id/editions/new/create', to: 'editions#create', as: 'edition_create'
  get 'editions/:edition_id/delete', to: 'editions#destroy', as: 'edition_delete'
  get 'editions/:edition_id/edit', to: 'editions#edit', as: 'edition_edit'
  patch 'editions/:edition_id/edit', to: 'editions#update', as: 'edition_update'
  get 'comment/:comment_id/edit', to:'comments#edit', as: 'comment_edit'
  patch 'comment/:comment_id/edit', to:'comments#comment_update', as: 'comment_update'
  get 'comment/:comment_id/delete', to: 'comments#comment_delete', as: 'comment_delete'
  get 'comment/:comment_id/like', to: 'comments#like', as: 'comment_like'
  get 'comment/:comment_id/dislike', to: 'comments#dislike', as: 'comment_dislike'
  get 'add_friend/:id', to: 'users#add_friend', as: 'add_friend'
  get 'remove_friend/:id', to: 'users#remove_friend', as: 'remove_friend'
  get 'friend_requests', to: 'users#requests', as: 'friend_requests'
  get 'accept_request/:id', to: "users#accept_request", as: 'accept_request'
  get 'decline_request/:id', to: "users#decline_request", as: 'decline_request'
  get 'cancel_request/:id', to: 'users#cancel_request', as: 'cancel_request'
  get 'home', to: 'users#home', as: 'home'
  get 'recommandation/new/:book_id', to: 'recommandations#new', as: 'rec_new'
  post 'recommandation/create/:book_id', to: 'recommandations#create', as: 'rec_create'
  get 'recommandation/:id/destroy', to: 'recommandations#destroy', as: 'rec_destroy'
  get 'forum', to: 'category#forum', as: 'forum'
  get 'forum/:category_id', to: 'category#show', as: 'category'
  get 'forum/topic/:topic_id', to: 'topics#show', as: 'topic'
  post 'forum/topic/:topic_id', to:'comments#comment_new_topic', as: 'comment_new_topic'
  get 'forum/topic/:topic_id/like', to: 'topics#like', as: 'topic_like'
  get 'forum/topic/:topic_id/dislike', to: 'topics#dislike', as: 'topic_dislike'
  get 'forum/new/:category_id/topic/', to: 'topics#new', as: 'topic_new'
  post 'forum/new/:category_id/topic/', to: 'topics#create', as: 'topic_create'
  get 'forum/topic/:topic_id/edit', to: 'topics#edit', as: 'topic_edit'
  patch 'forum/topic/:topic_id/edit', to: 'topics#update', as: 'topic_update'
  get 'forum/topic/:topic_id/delete', to: 'topics#destroy', as: 'topic_delete'



  authenticated :user do
    root 'users#home', as: :authenticated_root
  end

  devise_scope :user do
    root to: "devise/sessions#new"
  end


  get "*path" => redirect("/"), alert: "This page does not exist"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
