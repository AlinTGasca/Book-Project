class UsersController < ApplicationController
  before_action :is_user, only: [:home,:details, :update_list, :edit_list, :remove_list,:requests,:add_friend,:accept_request,:decline_request,:remove_friend]
  before_action :user_exist, only: [:profile, :list,:accept_request,:decline_request,:add_friend,:remove_friend,:friends,:reviews,:recommandations]
  before_action :book_list_exist, only: [:details, :edit_list, :update_list, :remove_list]

  def user_exist
    if (not User.exists?(params[:id])) && (not User.exists?(:username => params[:id]))
      redirect_to root_path, alert: 'The user does not exist. '
    end
  end

  def book_list_exist
    if not UsersToBook.exists?(params[:id_user_book])
      redirect_to root_path, alert: 'The book is not in your list. '
    end
  end

  def add_friend
    @user = User.find_by_uid!(params[:id])
    if (current_user.id != (@user.id))
    current_user.friend_request(@user)
    redirect_to user_profile_path(@user.username), :notice => 'Friend request sent.'
    else
      redirect_to user_profile_path(@user.username), :alert => "You don't have the rights to acces this page."
      end
  end

  def remove_friend
    @user = User.find_by_uid!(params[:id])
    if current_user.friends_with?(@user)
      current_user.remove_friend(@user)
      redirect_to user_profile_path(@user.username), :notice => 'Friendship terminated.'
    else redirect_to user_profile_path(@user.username), :alert => "You aren't a friend with this user."
    end
  end

  def accept_request
    @user = User.find_by_uid!(params[:id])
    if current_user.requested_friends.include?(@user)
    current_user.accept_request(@user)
    @user.create_activity(:friends, :owner => current_user)
    current_user.create_activity(:friends,:owner => @user)
    redirect_to friend_requests_path, :notice => 'Friend request accepted.'
    else
      redirect_to friend_requests_path, :alert => 'The request does not exist.'
      end
  end

  def decline_request
    @user = User.find_by_uid!(params[:id])
    if current_user.requested_friends.include?(@user)
    current_user.decline_request(@user)
    redirect_to friend_requests_path, :notice => 'Friend request declined.'
    else
      redirect_to friend_requests_path, :alert => 'The request does not exist.'
    end
  end

  def cancel_request
    @user = User.find_by_uid!(params[:id])
    if current_user.pending_friends.include?(@user)
    @user.decline_request(current_user)
    redirect_to user_profile_path(@user), :notice => 'Friend request canceled.'
    else redirect_to user_profile_path(@user), :alert =>"You aren't a friend with this user."
      end
  end

  def requests
    @requests = current_user.requested_friends
  end

def friends
  @user = User.find_by_uid!(params[:id])
  @friends = @user.friends.sort {|p1, p2| p1.username <=> p2.username}
end

  def home
  @ids = current_user.friends.pluck(:id)
  @activities = PublicActivity::Activity.where(owner_id: @ids).order('created_at DESC')
  end

  def profile
    @user = User.find_by_uid!(params[:id])
    ratings = UsersToBook.joins(:user, :book, :rating, :shelf).where(user_id: @user.id).where.not(ratings: {score: nil}, shelves: {status: 'Plan to Read'}).select("ratings.score")
    @avg_rat = 0
    ratings.each do |rating|
      @avg_rat = @avg_rat + rating.score
    end
    @comments = @user.comments
    @avg_rat = @avg_rat.to_f / ratings.size
    @completed = UsersToBook.joins(:user, :shelf).where(user_id: @user.id, shelves: {status: "Completed"}).count
    @p2r = UsersToBook.joins(:user, :shelf).where(user_id: @user.id, shelves: {status: "Plan to Read"}).count
    @reading = UsersToBook.joins(:user, :shelf).where(user_id: @user.id, shelves: {status: "Currently Reading"}).count
    @dropped = UsersToBook.joins(:user, :shelf).where(user_id: @user.id, shelves: {status: "Dropped"}).count
    if params[:sort] == "like"
      @comments = @comments.sort {|p1, p2| p2.get_likes.size <=> p1.get_likes.size}
    elsif params[:sort] == "dislike"
      @comments = @comments.sort {|p2, p1| p1.get_dislikes.size <=> p2.get_dislikes.size}
    elsif params[:sort] == "new"
      @comments = @comments.sort {|p1, p2| p2.created_at <=> p1.created_at}
    elsif params[:sort] == "old"
      @comments = @comments
    else
      @comments = @comments.sort {|p1, p2| p2.get_likes.size - p2.get_dislikes.size <=> p1.get_likes.size - p1.get_dislikes.size}
    end
    @comments = @comments.paginate(page: params[:page], per_page: 2)
    @status = UsersToBook.joins(:book, :shelf).select("books.id").where(user_id: @user.id).group('shelves.status').count
    @ratings = UsersToBook.joins(:book, :rating).select("books.id").where(user_id: @user.id).group('ratings.score').count
    @reviews = Review.where(user_id: @user.id)
    @review_sum = 0
    @reviews.each do |review|
      @review_sum = @review_sum + review.get_likes.size
      @review_sum = @review_sum - review.get_dislikes.size
    end
    @comments_count = Comment.where(user_id: @user).count
    @topic_count = Topic.where(user_id: @user).count
    @recs_count = Recommandation.where(user_id: @user).count
  end

  def index
    @users = User.paginate(:page => params[:page], :per_page => 2).all
  end


  def list
    @user = User.find_by_uid!(params[:id])
    @reading = UsersToBook.includes(:user, :book, :rating, :shelf).where(user_id: @user.id, shelves: {status: "Currently Reading"})
    @completed = UsersToBook.includes(:user, :book, :rating, :shelf).where(user_id: @user.id, shelves: {status: "Completed"})
    @dropped = UsersToBook.includes(:user, :book, :rating, :shelf).where(user_id: @user.id, shelves: {status: "Dropped"})
    @p2r = UsersToBook.includes(:user, :book, :rating, :shelf).where(user_id: @user.id, shelves: {status: "Plan to Read"})
    if params[:sort_r] == 'title_r'
      @reading = @reading.sort {|p1, p2| p1.book.title <=> p2.book.title}
    elsif params[:sort_r] == 'title_inv_r'
      @reading = @reading.sort {|p1, p2| p2.book.title <=> p1.book.title}
    elsif params[:sort_r] == 'rating_r'
      @reading = @reading.sort {|p1, p2| (p1.rating.score and p2.rating.score) ? p1.rating.score <=> p2.rating.score : (p1.rating.score ? -1 : 1)}
    elsif params[:sort_r] == 'rating_inv_r'
      @reading = @reading.sort {|p1, p2| (p1.rating.score and p2.rating.score) ? p2.rating.score <=> p1.rating.score : (p1.rating.score ? -1 : 1)}
      end
    if params[:sort_c] == 'title_c'
      @completed = @completed.sort {|p1, p2| p1.book.title <=> p2.book.title}
    elsif params[:sort_c] == 'title_inv_c'
      @completed = @completed.sort {|p1, p2| p2.book.title <=> p1.book.title}
    elsif params[:sort_c] == 'rating_c'
      @completed = @completed.sort {|p1, p2| (p1.rating.score and p2.rating.score) ? p1.rating.score <=> p2.rating.score : (p1.rating.score ? -1 : 1)}
    elsif params[:sort_c] == 'rating_inv_c'
      @completed = @completed.sort {|p1, p2| (p1.rating.score and p2.rating.score) ? p2.rating.score <=> p1.rating.score : (p1.rating.score ? -1 : 1)}
      end
    if params[:sort_d] == 'title_d'
      @dropped = @dropped.sort {|p1, p2| p1.book.title <=> p2.book.title}
    elsif params[:sort_d] == 'title_inv_d'
      @dropped = @dropped.sort {|p1, p2| p2.book.title <=> p1.book.title}
    elsif params[:sort_d] == 'rating_d'
      @dropped = @dropped.sort {|p1, p2| (p1.rating.score and p2.rating.score) ? p1.rating.score <=> p2.rating.score : (p1.rating.score ? -1 : 1)}
    elsif params[:sort_d] == 'rating_inv_d'
      @dropped = @dropped.sort {|p1, p2| (p1.rating.score and p2.rating.score) ? p2.rating.score <=> p1.rating.score : (p1.rating.score ? -1 : 1)}
      end
    if params[:sort_p] == 'title_p'
      @p2r = @p2r.sort {|p1, p2| p1.book.title <=> p2.book.title}
    elsif params[:sort_p] == 'title_inv_p'
      @p2r = @p2r.sort {|p1, p2| p2.book.title <=> p1.book.title}
    elsif params[:sort_p] == 'rating_p'
      @p2r = @p2r.sort {|p1, p2| (p1.rating.score and p2.rating.score) ? p1.rating.score <=> p2.rating.score : (p1.rating.score ? -1 : 1)}
    elsif params[:sort_p] == 'rating_inv_p'
      @p2r = @p2r.sort {|p1, p2| (p1.rating.score and p2.rating.score) ? p2.rating.score <=> p1.rating.score : (p1.rating.score ? -1 : 1)}
    end
  end

  def remove_list
    @UB = UsersToBook.find(params[:id_user_book])
    if current_user.id == (@UB.user_id)
      @UB.destroy
      redirect_to list_path(current_user.username), :notice => "The book has been removed from your list."
    else
      redirect_to list_path(current_user.username), :alert => "You don't have the rights to acces this page."
    end
  end

  def details
    @users_to_book = UsersToBook.find(params[:id_user_book])
    if current_user.id == @users_to_book.user_id
      @ratings = Rating.all.order('created_at DESC')
      @shelves = Shelf.all.order('created_at ASC')
      @book = Book.find(@users_to_book.book_id)
      @book_rating = UsersToBook.joins(:rating).where(user_id: current_user.id, book_id: @users_to_book.book_id).pluck(:rating_id)
      @book_shelf = UsersToBook.joins(:shelf).where(user_id: current_user.id, book_id: @users_to_book.book_id).pluck(:shelf_id)
    else
      redirect_to list_path(current_user.username), :alert => "You don't have the rights to acces this page."
    end
  end

  def edit_list
    @users_to_book = Book.find(params[:id])
    if (current_user.id == (@users_to_book.user_id))
      respond_to {|format| format.html}
    else
      redirect_to book_path(@users_to_book.book_id), :alert => "You don't have the rights to acces this page."
    end
  end


  def update_list
    @users_to_book = UsersToBook.find(params[:id_user_book])
    if current_user.id == (@users_to_book.user_id)
      if UsersToBook.where(id: @users_to_book.id).update(:rating_id => params[:users_to_book][:rating], :shelf_id => params[:users_to_book][:shelf], :start_reading => params[:users_to_book][:start_reading], :end_reading => params[:users_to_book][:end_reading], :notes => params[:users_to_book][:notes])
        redirect_to list_path(current_user.username), :notice => 'The book has been updated.'
      else
        render 'details'
      end
    else
      redirect_to root_path, alert: "You don't have the rights to acces this page."
    end
  end

  def recommandations
    @user = User.find_by_uid!(params[:id])
    @recs = PublicActivity::Activity.where(owner_id: @user.id,trackable_type: 'Recommandation',).order('created_at DESC')
    @recs = @recs.paginate(page: params[:page], per_page: 2)
  end

  def forum
    @user = User.find_by_uid!(params[:id])
    @posts = PublicActivity::Activity.where(owner_id: @user.id,key: ['comment.commented_on_topic','topic.topic']).order('created_at DESC')
    @posts = @posts.paginate(page: params[:page], per_page: 2)
  end

  def reviews
    @user = User.find_by_uid!(params[:id])
    @reviews = Review.includes(:rating, :user, :book).where(user_id: @user.id).sort {|p2, p1| p1.get_likes.size <=> p2.get_likes.size}
    if params[:sort] == "like"
      @reviews = @reviews.sort {|p1, p2| p2.get_likes.size <=> p1.get_likes.size}
    elsif params[:sort] == "dislike"
      @reviews = @reviews.sort {|p2, p1| p1.get_dislikes.size <=> p2.get_dislikes.size}
    elsif params[:sort] == "new"
      @reviews = @reviews.sort {|p1, p2| p2.created_at <=> p1.created_at}
    elsif params[:sort] == "old"
      @reviews = @reviews
    else
      @reviews = @reviews.sort {|p1, p2| p2.get_likes.size - p2.get_dislikes.size <=> p1.get_likes.size - p1.get_dislikes.size}
    end
    @reviews = @reviews.paginate(page: params[:page], per_page: 2)
  end


  def is_user
    if !user_signed_in?
      redirect_to root_path, :alert => "You must be logged in to acces this page."
    end
  end

  private
  def book_params
    params.require(:users_to_book).permit(:rating, :shelf, :start_reading, :end_reading, :notes)
  end


end

