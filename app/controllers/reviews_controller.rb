class ReviewsController < ApplicationController
  before_action :is_user, only: [:new, :create, :edit, :update, :destroy, :like, :dislike]
  before_action :book_exist, only: [:new,:create]
  before_action :review_exist, only: [:edit,:update,:destroy, :like, :dislike]
  before_action :review_list, only: [:new]
  def new
    @review = Review.new
    @ratings = Rating.all
    @book = Book.find(params[:book_id])
  end


  def create
    @review = Review.new(:content=>params[:content],:rating_id=>params[:rating],:book_id=>params[:book_id],:user_id=>current_user.id)
    @ratings = Rating.all
    @book = Book.find(params[:book_id])
    @ratings = Rating.all
    if @review.valid?
      @review.save
      redirect_to book_path(params[:book_id]), notice: 'Your review has been posted.'
    else
      render 'new'
    end
  end

  def edit
    @review = Review.find(params[:review_id])
    if (current_user.id == (@review.user_id) || current_user.try(:admin?))
    @ratings = Rating.all
    @book = Book.find(@review.book_id)
    else redirect_to book_path(@review.book_id), :alert => "You don't have the rights to acces this page."
      end
  end

  def update
    @review = Review.find(params[:review_id])
    @ratings = Rating.all
    if (current_user.id == (@review.user_id) || current_user.try(:admin?))
    @book = Book.find(@review.book_id)
    if @review.update(:content=>params[:review][:content],:rating_id=>params[:review][:rating])
    redirect_to book_path(@review.book_id), :notice => "The review has been updated."
  else
    render 'edit'
    end
    else redirect_to book_path(@review.book_id), :notice => "You don't have the rights to acces this page."
    end
  end

  def destroy
    @review = Review.find(params[:review_id])
    if (current_user.id == (@review.user_id) || current_user.try(:admin?))
      @review.destroy
      redirect_to book_path(@review.book_id), :notice => "The book has been removed from your list."
    else redirect_to book_path(@review.book_id), :alert => "You don't have the rights to acces this page."
    end
  end
  def like
    @review = Review.find(params[:review_id])
    @review.upvote_by current_user
    redirect_back fallback_location: root_path
  end

  def dislike
    @review = Review.find(params[:review_id])
    @review.downvote_by current_user
    redirect_back fallback_location: root_path
  end

  def is_user
    if !user_signed_in?
      redirect_to root_path, :alert => "You don't have the rights to acces this page."
    end
  end

  def book_exist
    if not Book.exists?params[:book_id]
      redirect_to root_path, alert: 'The book does not exist. '
    end
  end

  def review_exist
    if not Review.exists?params[:review_id]
      redirect_to root_path, alert: 'The review does not exist.'
    end
  end

  def review_list
    @UB = UsersToBook.where(book_id: params[:book_id], user_id: current_user.id).limit(1)
    if @UB.count == 0
      redirect_to book_path(params[:book_id]), notice: "You can't review a book that isn't in your list."
      end
    @UB2 = UsersToBook.where(book_id: params[:book_id], user_id: current_user.id).limit(1).pluck(:shelf_id)
    if @UB2[0] == Shelf.find_by(status: 'Plan to Read').id
      redirect_to book_path(params[:book_id]), notice: "You can't review a book that you haven't read yet (It must be Completed/Dropped/Currenlty Reading)."
    end
  end


  private
  def review_params
    params.require(:review).permit(:content,:rating,:book_id).merge(user_id: current_user.id)
  end

end
