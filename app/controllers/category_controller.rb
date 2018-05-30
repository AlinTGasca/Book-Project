class CategoryController < ApplicationController
  before_action :category_exist, only: [:show]

  def forum
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:category_id])
    @topics = Topic.where(category_id: @category)
    @topics = @topics.sort{ |p1,p2| Topic.last_post(p2.id).created_at <=> Topic.last_post(p1.id).created_at }
    @topics = @topics.paginate(page: params[:page], per_page: 2)
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
