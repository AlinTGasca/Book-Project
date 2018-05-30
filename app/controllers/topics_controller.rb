class TopicsController < ApplicationController
  before_action :is_user, only: [:new, :create, :edit, :update, :destroy, :like, :dislike]
  before_action :category_exist, only: [:new,:create]
  before_action :topic_exist, only: [:edit,:update,:destroy, :like, :dislike]
  def show
    @topic = Topic.find(params[:topic_id])
    @comments = @topic.comments
    @comments = @comments.paginate(page: params[:page], per_page: 2)
  end

  def new
    @topic = Topic.new
    @category = Category.find(params[:category_id])
  end


  def create
    @topic = Topic.new(:body=>params[:body],:title=>params[:title],:category_id=>params[:category_id],:user_id=>current_user.id)
    @category = Category.find(params[:category_id])
    if @topic.valid?
      @topic.save
      @topic.create_activity(:topic, :owner => current_user)
      redirect_to topic_path(@topic), notice: 'Your topic has been posted.'
    else
      render 'topicnew'
    end
  end

  def edit
    @topic = Topic.find(params[:topic_id])
    if (current_user.id == (@topic.user_id) || current_user.try(:admin?))
      @category = Category.find(@topic.category_id)
    else redirect_to topic_path(@topic), :alert => "You don't have the rights to acces this page."
    end
  end

  def update
    @topic = Topic.find(params[:topic_id])
    if (current_user.id == (@topic.user_id) || current_user.try(:admin?))
      if @topic.update(:body=>params[:topic][:body],:title=>params[:topic][:title])
        redirect_to topic_path(@topic), :notice => "The topic has been updated."
      else
        render 'topicedit'
      end
    else redirect_to topic_path(@topic), :notice => "You don't have the rights to acces this page."
    end
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    if (current_user.id == (@topic.user_id) || current_user.try(:admin?))
      @topic.destroy
      Topic.delete_activities(@topic.id)
      redirect_to category_path(@topic.category_id), :notice => "Your topic has been deleted."
    else redirect_to topic_path(@topic), :alert => "You don't have the rights to acces this page."
    end
  end

  def like
    @topic = Topic.find(params[:topic_id])
    if current_user.voted_up_on?(@topic)
      @topic.unliked_by current_user
    else
      @topic.upvote_by current_user
    end
    redirect_back fallback_location: root_path

  end

  def dislike
    @topic = Topic.find(params[:topic_id])
    if current_user.voted_down_on?(@topic)
      @topic.undisliked_by current_user
    else
      @topic.downvote_by current_user
    end
    redirect_back fallback_location: root_path
  end

  def is_user
    if !user_signed_in?
      redirect_to root_path, :alert => "You don't have the rights to acces this page."
    end
  end

  def category_exist
    if not Category.exists?params[:category_id]
      redirect_to root_path, alert: 'The category does not exist. '
    end
  end

  def topic_exist
    if not Topic.exists?params[:topic_id]
      redirect_to root_path, alert: 'The topic does not exist.'
    end
  end
end
