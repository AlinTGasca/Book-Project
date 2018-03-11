class UsersController < ApplicationController
  before_action :is_user, only: [:details,:update_list, :edit_list, :remove_list]
  before_action :user_exist, only: [:profile,:list]
  before_action :book_list_exist, only: [:details,:update_list, :edit_list, :remove_list]
      def user_exist
      if (not User.exists?(params[:id])) && (not User.exists?(:username=>params[:id]))
      redirect_to root_path, alert: 'The user does not exist. '
      end
  end

  def book_list_exist
    if not UsersToBook.exists?params[:id_user_book]
      redirect_to root_path, alert: 'The book is not in your list. '
    end
  end

  def profile
    @user = User.find_by_uid!(params[:id])
    ratings = UsersToBook.joins(:user, :book,:rating).where(user_id: User.find_by_uid!(params[:id]).id).where.not(ratings: { score: nil }).select("ratings.score")
    @avg_rat = 0
    ratings.each do |rating|
      @avg_rat = @avg_rat + rating.score
    end
    @avg_rat = @avg_rat.to_f/ratings.size
  end

  def index
    @users = User.all
  end


  def list
  @books = UsersToBook.joins(:user, :book,:rating,:shelf).where(user_id: User.find_by_uid!(params[:id]).id).select("books.*, ratings.score,shelves.status,users_to_books.*")
  end

  def remove_list
    @UB = UsersToBook.find(params[:id_user_book])
    if current_user.id == (@UB.user_id)
    @UB.destroy
    redirect_to list_path(current_user.username), :notice => "The book has been removed from your list."
    else redirect_to list_path(current_user.username), :alert => "You don't have the rights to acces this page."
    end
  end

  def details
    @book = UsersToBook.joins(:book, :user).where(id: params[:id_user_book]).select('users_to_books.*, books.*').first
    if current_user.id == @book.user_id
    @ratings = Rating.all.order('created_at DESC')
    @shelves = Shelf.all.order('created_at ASC')
    @book_rating = UsersToBook.joins(:rating).where(user_id: current_user.id, book_id: @book.book_id).pluck(:rating_id)
    @book_shelf = UsersToBook.joins(:shelf).where(user_id: current_user.id, book_id: @book.book_id).pluck(:shelf_id)
      else redirect_to list_path(current_user.username), :alert => "You don't have the rights to acces this page."
  end
  end

  def edit_list
    @book = Book.find(params[:id])
    if (current_user.id == (@book.user_id))
    respond_to { |format| format.html }
    else redirect_to book_path(@review.book_id), :alert => "You don't have the rights to acces this page."
    end
  end


  def update_list
    @book = UsersToBook.find(params[:id_user_book])
    if current_user.id == (@book.user_id)
      if UsersToBook.where(id: @book.id).update(:rating_id=>params[:rating],:shelf_id=>params[:shelves])
        redirect_to list_path(current_user.username), :notice => 'The book has been updated.'
      else render 'details'
      end
    else redirect_to root_path, alert: "You don't have the rights to acces this page."
    end
  end

  def is_user
    if !user_signed_in?
      redirect_to root_path, :alert => "You don't have the rights to acces this page."
    end
  end

  end

