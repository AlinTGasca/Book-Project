class CommentsController < ApplicationController
  before_action :is_user, only: [:comment_new_book,:comment_new_user,:comment_new_author, :comment_update, :edit, :comment_delete, :like, :dislike]
  before_action :book_exist, only: [:comment_new_book]
  before_action :user_exist, only: [:comment_new_user]
  before_action :author_exist, only: [:comment_new_author]
  before_action :comment_exist, only: [:comment_update, :edit, :comment_delete, :like, :dislike]


  def comment_new_author
    @author = Author.find(params[:id])
    @author.comments << @comment = Comment.new(body: params[:body], user_id: current_user.id)
    if params[:body].present?
      @comment.create_activity(:commented_on_author, :owner => current_user)
      redirect_to @author, :notice => "New comment added."
    else
      redirect_to @author, :notice => "Can't add empty comments."
    end
  end

  def comment_new_user
    @user = User.find_by_uid!(params[:id])
    @user.comments << @comment = Comment.new(body: params[:body], user_id: current_user.id)
    if params[:body].present?
      @comment.create_activity(:commented_on_user, :owner => current_user)
      redirect_to user_profile_path(@user), :notice => "New comment added."
    else
      redirect_to user_profile_path(@user), :notice => "Can't add empty comments."
    end
  end

  def comment_new_book
    @book = Book.find(params[:id])
    @book.comments << @comment = Comment.new(body: params[:body], user_id: current_user.id)
    if params[:body].present?
      @comment.create_activity(:commented_on_book, :owner => current_user)
      redirect_to book_path(@book), :notice => "New comment added."
    else
      redirect_to book_path(@book), :notice => "Can't add empty comments."
    end
  end

  def comment_new_topic
    @topic = Topic.find(params[:topic_id])
    @topic.comments << @comment = Comment.new(body: params[:body], user_id: current_user.id)
    if params[:body].present?
      @comment.create_activity(:commented_on_topic, :owner => current_user)
      redirect_to topic_path(@topic), :notice => "New comment added."
    else
      redirect_to topic_path(@topic), :notice => "Can't add empty comments."
    end
  end

  def comment_delete
    _comment = Comment.find(params[:comment_id])
    Comment.delete_activities(_comment.id)
    _comment.destroy
    redirect_back fallback_location: root_path, :notice => "Comment deleted."
  end



  def edit
    @comment = Comment.find(params[:comment_id])
    if (current_user.id == (@comment.user_id) || current_user.try(:admin?))
    else redirect_back fallback_location: root_path, :alert => "You don't have the rights to acces this page."
    end
  end

  def comment_update
    @comment = Comment.find(params[:comment_id])
    if (current_user.id == (@comment.user_id) || current_user.try(:admin?))
      if @comment.update(body: params[:comment][:body])
        if(@comment.commentable_type=="Author")
        redirect_to author_path(@comment.commentable_id), :notice => "The comment has been updated."
        elsif (@comment.commentable_type=="User")
          redirect_to user_profile_path(@comment.commentable_id), :notice => "The comment has been updated."
        elsif (@comment.commentable_type=="Book")
          redirect_to book_path(@comment.commentable_id), :notice => "The comment has been updated."
          else redirect_to root, alert: "Redirect problem."
        end
      else
        render 'edit'
      end
    else redirect_to @comment.commentable_id, :alert => "You don't have the rights to acces this page."
    end
  end


  def like
    @comment = Comment.find(params[:comment_id])
    if current_user.voted_up_on?(@comment)
      @comment.unliked_by current_user
    else
    @comment.upvote_by current_user
    end
    redirect_back fallback_location: root_path

  end

  def dislike
    @comment = Comment.find(params[:comment_id])
    if current_user.voted_down_on?(@comment)
      @comment.undisliked_by current_user
    else
      @comment.downvote_by current_user
    end
    redirect_back fallback_location: root_path
  end

  def book_exist
    if not Book.exists?params[:book_id]
      redirect_to root_path, alert: 'The book does not exist. '
    end
  end

  def user_exist
    if (not User.exists?(params[:id])) && (not User.exists?(:username=>params[:id]))
      redirect_to root_path, alert: 'The user does not exist. '
    end
  end

  def book_exist
    if not Book.exists?params[:id]
      redirect_to root_path, alert: 'The book does not exist. '
    end
  end

  def author_exist
    if not Author.exists?(params[:id])
    then redirect_to root_path, alert: 'The author does not exist.'
    end
  end

  def comment_exist
    if not Comment.exists?(params[:comment_id])
    then redirect_to root_path, alert: 'The comment does not exist.'
    end
  end

  def is_user
    if !user_signed_in?
      redirect_to root_path, :alert => "You don't have the rights to acces this page."
    end
  end
  
end
