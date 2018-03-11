class AuthorsController < ApplicationController
  before_action :is_admin, only: [:new,:create,:edit,:update,:destroy]
  before_action :author_exist, only: [:edit,:update,:destroy,:show]
  def index
    @authors = Author.all
  end

  def show
    @author = Author.find(params[:id])
    @books = Book.joins(:books_to_authors).where(books_to_authors: {author_id: @author.id})
  end

  def edit
    @author = Author.find(params[:id])
  end


  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)

    if @author.save
      redirect_to @author, :notice => "New author added."
    else
      render 'new'
    end
  end

  def update
    @author = Author.find(params[:id])
    if @author.update(author_params)
      redirect_to @author, :notice => "The author has been updated."
    else
      render 'edit'
    end
  end

  def destroy
    @author = Author.find(params[:id])
    BooksToAuthor.where(author_id: @author.id).destroy_all
    @author.destroy
    redirect_to authors_path, :notice => "The author has been deleted."
    end

  def is_admin
    if !current_user.try(:admin?)
      redirect_to root_path, :alert => "You don't have the rights to acces this page."
    end
  end

  def author_exist
    if not Author.exists?(params[:id])
    then redirect_to root_path, alert: 'The author does not exist.'
    end
  end

  private
  def author_params
    params.require(:author).permit(:lastName,:firstName, :bios,:death,:birth,:avatar)
  end
end
