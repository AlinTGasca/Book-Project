class BooksController < ApplicationController
  before_action :is_user, only: [:update_list,:add_to_list,:edit_list]
  before_action :is_admin, only: [:new,:create,:edit,:update,:destroy]
  before_action :book_exist, only: [:edit,:update,:destroy,:show,:update_list,:add_to_list,:edit_list]
  def index
    @books = Book.all
  end



  def show
    @book = Book.find(params[:id])
    @ratings = Rating.all.order('created_at DESC')
    @shelves = Shelf.all.order('created_at ASC')
    @authors = Author.joins(:books_to_authors).where(books_to_authors: {book_id: @book.id})
    @reviews = Review.includes(:rating,:user).where(book_id: @book.id).sort { |p2, p1| p1.get_likes.size <=> p2.get_likes.size }
    if user_signed_in?
    @book_rating = UsersToBook.joins(:rating).where(user_id: current_user.id, book_id: @book.id).pluck(:rating_id)
    @book_shelf = UsersToBook.joins(:shelf).where(user_id: current_user.id, book_id: @book.id).pluck(:shelf_id)
    if UsersToBook.where(book_id: @book.id,user_id: current_user.id).exists?
    @book_list = UsersToBook.joins(:book, :user).where(book_id: params[:id],user_id: current_user.id).first
    end
      end
  end

  def edit
    @book = Book.find(params[:id])
    @authors = Author.all
    @book_authors = Author.joins(:books_to_authors).where(books_to_authors: {book_id: @book.id}).pluck(:author_id)
  end


  def new
    @book = Book.new
    @authors = Author.all
  end

  def create
    @book = Book.new(book_params)
    @authors = Author.all
    if @book.save
      params[:book][:authors].each do |author|
        if (author!="")
      BooksToAuthor.new(:book_id=>@book.id,:author_id=>author).save
          end
      end
      redirect_to @book, :notice => "The book has been created."
    else
      render 'new'
    end
  end

  def update
    @book = Book.find(params[:id])

    if @book.update(book_params)
      BooksToAuthor.where(book_id: @book.id).destroy_all
        params[:book][:authors].each do |author|
          if (author!="")
            BooksToAuthor.new(:book_id=>@book.id,:author_id=>author).save
          end
        end
      redirect_to @book, :notice => "The book has been updated."
    else
      render 'edit'
    end
  end

  def destroy
    @book = Book.find(params[:id])
    BooksToAuthor.where(book_id: @book.id).destroy_all
    UsersToBooks.where(book_id: @book.id).destroy_all
    @book.destroy
    redirect_to books_path, :notice => "The book has been deleted."
  end

  def add_to_list
      if request.post?
      @book = Book.find(params[:id])
      UsersToBook.new(:book_id=>@book.id,:user_id=>current_user.id,:rating_id=>params[:rating],:shelf_id=>params[:shelves]).save
      redirect_to @book, :notice => "The book has been added to your list."
        end
    end


  def edit_list
    @book = book.find(params[:id])
    respond_to { |format| format.html }
  end

  def update_list
    @book = Book.find(params[:id])
      if UsersToBook.where(user_id: current_user.id, book_id: @book.id).update(:rating_id=>params[:rating],:shelf_id=>params[:shelves])
        redirect_to @book, :notice=> "The book has been updated."
      else render 'edit_list'
      end
    end

  def is_user
    if !user_signed_in?
      redirect_to root_path, :alert => "You don't have the rights to acces this page."
    end
  end

  def is_admin
    if !current_user.try(:admin?)
      redirect_to root_path, :alert => "You don't have the rights to acces this page."
    end
  end

  def book_exist
    if not Book.exists?(params[:id])
      then redirect_to root_path, :alert => 'The book does not exist.'
    end
  end


  private
  def book_params
    params.require(:book).permit(:title,:description, :published, :authors, :avatar)
  end



end
