class AuthorsController < ApplicationController
  before_action :is_admin, only: [:new,:create,:edit,:update,:destroy]
  before_action :author_exist, only: [:edit,:update,:destroy,:show]
  def index
    @authors = Author.paginate(:page => params[:page], :per_page => 2).all
  end

  def show
    @author = Author.find(params[:id])
    @books = Book.joins(:books_to_authors).where(books_to_authors: {author_id: @author.id}).order('Title ASC')
    @comments = @author.comments
    if params[:sort]=="like"
      @comments = @comments.sort { |p1, p2| p2.get_likes.size <=> p1.get_likes.size}
    elsif params[:sort]=="dislike"
      @comments = @comments.sort { |p2, p1| p1.get_dislikes.size <=> p2.get_dislikes.size }
    elsif params[:sort]=="new"
      @comments = @comments.sort { |p1, p2| p2.created_at <=> p1.created_at}
    elsif params[:sort]=="old"
      @comments = @comments
    else
      @comments = @comments.sort { |p1, p2| p2.get_likes.size-p2.get_dislikes.size <=> p1.get_likes.size-p1.get_dislikes.size }
    end
    @comments = @comments.paginate(page: params[:page], per_page: 2)
    if params[:sort_b]=='title'
      @books = @books.sort { |p1, p2| p1.title.upcase <=> p2.title.upcase}
    elsif params[:sort_b]=='title_inv'
      @books = @books.sort { |p1, p2| p2.title.upcase <=> p1.title.upcase}
    elsif params[:sort_b]=='published_inv'
      @books = @books.reject(&:published) + @books.select(&:published).sort_by(&:published)
    elsif params[:sort_b]=='published'
      @books = @books.select(&:published).sort_by {|x| Date.today - x.published} + @books.reject(&:published)
    elsif params[:sort_b]=='score_inv'
      @books = @books.sort{ |p1,p2| Book.score(p1.id) <=> Book.score(p2.id) }
    elsif params[:sort_b]=='score'
      @books = @books.sort{ |p1,p2| Book.score(p2.id) <=> Book.score(p1.id) }
    elsif params[:sort_b] == 'popularity'
      @books = @books.sort{ |p1,p2| UsersToBook.joins(:book).where(book_id: p2.id).count <=> UsersToBook.joins(:book).where(book_id: p1.id).count}
    elsif params[:sort_b] == 'popularity_inv'
      @books = @books.sort{ |p1,p2| UsersToBook.joins(:book).where(book_id: p1.id).count <=> UsersToBook.joins(:book).where(book_id: p2.id).count}
    end
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
    params.require(:author).permit(:lastName,:firstName, :bios,:death,:birth,:avatar,:gender,:country)
  end
end
