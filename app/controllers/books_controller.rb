class BooksController < ApplicationController
  before_action :is_user, only: [:update_list,:add_to_list,:edit_list]
  before_action :is_admin, only: [:new,:create,:edit,:update,:destroy]
  before_action :book_exist, only: [:edit,:update,:destroy,:show,:update_list,:add_to_list,:edit_list]
  def index
    @books = Book.paginate(:page => params[:page], :per_page => 2).all
    @genres = Genre.all.order(:name)
  end


  def show
    @book = Book.find(params[:id])
    @ratings = Rating.all.order('created_at DESC')
    @shelves = Shelf.all.order('created_at ASC')
    @authors = Author.joins(:books_to_authors).where(books_to_authors: {book_id: @book.id})
    @genres = Genre.joins(:books_to_genres).where(books_to_genres: {book_id: @book.id})
    @avg_rat = 0
    @ratings_given = UsersToBook.joins(:book,:rating).where(book_id: @book.id).where.not(ratings: { score: nil }).select("ratings.score")
    @ratings_given.each do |rating|
      @avg_rat = @avg_rat + rating.score
    end
    @avg_rat = @avg_rat.to_f/@ratings_given.size
    @members = UsersToBook.where(book_id: @book.id).count
    @review_count = Review.where(book_id: @book.id).count
    @comment_count = @book.comments.count
    @comments = @book.comments
    @reviews = Review.includes(:rating,:user).where(book_id: @book.id).limit(2).sort { |p2, p1| p1.get_likes.size <=> p2.get_likes.size }
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
    @comments = @comments.paginate(:page => params[:page], :per_page => 2)
    if user_signed_in?
      @book_rating = UsersToBook.joins(:rating).where(user_id: current_user.id, book_id: @book.id).pluck(:rating_id)
      @book_shelf = UsersToBook.joins(:shelf).where(user_id: current_user.id, book_id: @book.id).pluck(:shelf_id)
      if UsersToBook.where(book_id: @book.id,user_id: current_user.id).exists?
        @book_list = UsersToBook.joins(:book, :user).where(book_id: params[:id],user_id: current_user.id).first
      end
    end
    end

    def reviews
      @book = Book.find(params[:id])
      @ratings = Rating.all.order('created_at DESC')
      @shelves = Shelf.all.order('created_at ASC')
      @authors = Author.joins(:books_to_authors).where(books_to_authors: {book_id: @book.id})
      @genres = Genre.joins(:books_to_genres).where(books_to_genres: {book_id: @book.id})
      @avg_rat = 0
      @ratings_given = UsersToBook.joins(:book,:rating).where(book_id: @book.id).where.not(ratings: { score: nil }).select("ratings.score")
      @ratings_given.each do |rating|
        @avg_rat = @avg_rat + rating.score
      end
      @avg_rat = @avg_rat.to_f/@ratings_given.size
      @members = UsersToBook.where(book_id: @book.id).count
      @review_count = Review.where(book_id: @book.id).count
      @comment_count = @book.comments.count
      @reviews = Review.includes(:rating,:user).where(book_id: @book.id).sort { |p2, p1| p1.get_likes.size <=> p2.get_likes.size }
      if user_signed_in?
        @book_rating = UsersToBook.joins(:rating).where(user_id: current_user.id, book_id: @book.id).pluck(:rating_id)
        @book_shelf = UsersToBook.joins(:shelf).where(user_id: current_user.id, book_id: @book.id).pluck(:shelf_id)
        if UsersToBook.where(book_id: @book.id,user_id: current_user.id).exists?
          @book_list = UsersToBook.joins(:book, :user).where(book_id: params[:id],user_id: current_user.id).first
        end
      end
      if params[:sort]=="like"
        @reviews = @reviews.sort { |p1, p2| p2.get_likes.size <=> p1.get_likes.size}
      elsif params[:sort]=="dislike"
        @reviews = @reviews.sort { |p2, p1| p1.get_dislikes.size <=> p2.get_dislikes.size }
      elsif params[:sort]=="new"
        @reviews = @reviews.sort { |p1, p2| p2.created_at <=> p1.created_at}
      elsif params[:sort]=="old"
        @reviews = @reviews
      else
        @reviews = @reviews.sort { |p1, p2| p2.get_likes.size-p2.get_dislikes.size <=> p1.get_likes.size-p1.get_dislikes.size }
    end
    @reviews = @reviews.paginate(:page => params[:page], :per_page => 2)
    end

  def stats
    @book = Book.find(params[:id])
    @ratings = Rating.all.order('created_at DESC')
    @shelves = Shelf.all.order('created_at ASC')
    @authors = Author.joins(:books_to_authors).where(books_to_authors: {book_id: @book.id})
    @genres = Genre.joins(:books_to_genres).where(books_to_genres: {book_id: @book.id})
    @avg_rat = 0
    @ratings_given = UsersToBook.joins(:book,:rating).where(book_id: @book.id).where.not(ratings: { score: nil }).select("ratings.score")
    @ratings_given.each do |rating|
      @avg_rat = @avg_rat + rating.score
    end
    @avg_rat = @avg_rat.to_f/@ratings_given.size
    @members = UsersToBook.where(book_id: @book.id).count
    @review_count = Review.where(book_id: @book.id).count
    @comment_count = @book.comments.count
    if user_signed_in?
      @book_rating = UsersToBook.joins(:rating).where(user_id: current_user.id, book_id: @book.id).pluck(:rating_id)
      @book_shelf = UsersToBook.joins(:shelf).where(user_id: current_user.id, book_id: @book.id).pluck(:shelf_id)
      if UsersToBook.where(book_id: @book.id,user_id: current_user.id).exists?
        @book_list = UsersToBook.joins(:book, :user).where(book_id: params[:id],user_id: current_user.id).first
      end
    end

  end

  def editions
    @book = Book.find(params[:id])
    @ratings = Rating.all.order('created_at DESC')
    @shelves = Shelf.all.order('created_at ASC')
    @authors = Author.joins(:books_to_authors).where(books_to_authors: {book_id: @book.id})
    @genres = Genre.joins(:books_to_genres).where(books_to_genres: {book_id: @book.id})
    @avg_rat = 0
    @ratings_given = UsersToBook.joins(:book,:rating).where(book_id: @book.id).where.not(ratings: { score: nil }).select("ratings.score")
    @ratings_given.each do |rating|
      @avg_rat = @avg_rat + rating.score
    end
    @avg_rat = @avg_rat.to_f/@ratings_given.size
    @members = UsersToBook.where(book_id: @book.id).count
    @review_count = Review.where(book_id: @book.id).count
    @comment_count = @book.comments.count
    if user_signed_in?
      @book_rating = UsersToBook.joins(:rating).where(user_id: current_user.id, book_id: @book.id).pluck(:rating_id)
      @book_shelf = UsersToBook.joins(:shelf).where(user_id: current_user.id, book_id: @book.id).pluck(:shelf_id)
      if UsersToBook.where(book_id: @book.id,user_id: current_user.id).exists?
        @book_list = UsersToBook.joins(:book, :user).where(book_id: params[:id],user_id: current_user.id).first
      end
    end


    @editions = @book.editions
    if params[:sort]=='title'
      @editions = @editions.sort { |p1, p2| p1.title <=> p2.title}
    elsif params[:sort]=='title_inv'
      @editions = @editions.sort { |p1, p2| p2.title <=> p1.title}
    elsif params[:sort]=='published_inv'
      @editions =   @editions.select(&:pubslished).sort_by(&:pubslished) + @editions.reject(&:pubslished)
    elsif params[:sort]=='published'
      @editions = @editions.select(&:pubslished).sort_by {|x| Date.today - x.pubslished} + @editions.reject(&:pubslished)
    elsif params[:sort]=='publisher'
      @editions = @editions.sort { |p1, p2| (p1.publisher!="" and p2.publisher!="") ? p1.publisher <=> p2.publisher : ( p1.publisher!="" ? -1 : 1 )}
    elsif params[:sort]=='publisher_inv'
      @editions =  @editions.sort { |p1, p2| (p1.publisher!="" and p2.publisher!="") ? p2.publisher <=> p1.publisher : ( p1.publisher!="" ? -1 : 1 )}
      elsif params[:sort]=='country'
        @editions = @editions.sort { |p1, p2| p1.country_name <=> p2.country_name}
    elsif params[:sort]=='country_inv'
      @editions = @editions.sort { |p1, p2| p2.country_name <=> p1.country_name}
    end
  end


  def recommandations
    @book = Book.find(params[:id])
    @ratings = Rating.all.order('created_at DESC')
    @shelves = Shelf.all.order('created_at ASC')
    @authors = Author.joins(:books_to_authors).where(books_to_authors: {book_id: @book.id})
    @genres = Genre.joins(:books_to_genres).where(books_to_genres: {book_id: @book.id})
    @avg_rat = 0
    @ratings_given = UsersToBook.joins(:book,:rating).where(book_id: @book.id).where.not(ratings: { score: nil }).select("ratings.score")
    @ratings_given.each do |rating|
      @avg_rat = @avg_rat + rating.score
    end
    @avg_rat = @avg_rat.to_f/@ratings_given.size
    @members = UsersToBook.where(book_id: @book.id).count
    @review_count = Review.where(book_id: @book.id).count
    @comment_count = @book.comments.count
    if user_signed_in?
      @book_rating = UsersToBook.joins(:rating).where(user_id: current_user.id, book_id: @book.id).pluck(:rating_id)
      @book_shelf = UsersToBook.joins(:shelf).where(user_id: current_user.id, book_id: @book.id).pluck(:shelf_id)
      if UsersToBook.where(book_id: @book.id,user_id: current_user.id).exists?
        @book_list = UsersToBook.joins(:book, :user).where(book_id: params[:id],user_id: current_user.id).first
      end
    end
    @recs =Recommandation.select('*,count(second_book_id) as count_sec').includes(:second_book).where(first_book_id: @book.id).group(:second_book_id).order('count_sec desc')
    @recs = @recs.paginate(page: params[:page], per_page: 2)
  end

  def edit
    @book = Book.find(params[:id])
    @authors = Author.all
    @genres = Genre.all
    @book_genres = Genre.joins(:books_to_genres).where(books_to_genres: {book_id: @book.id}).pluck(:genre_id)
    @book_authors = Author.joins(:books_to_authors).where(books_to_authors: {book_id: @book.id}).pluck(:author_id)
  end


  def new
    @book = Book.new
    @authors = Author.all
    @genres = Genre.all
  end

  def create
    @book = Book.new(book_params)
    @authors = Author.all
    @genres = Genre.all
    if @book.save
      params[:book][:authors].each do |author|
        if (author!="")
      BooksToAuthor.new(:book_id=>@book.id,:author_id=>author).save
          end
      end
      params[:book][:genres].each do |genre|
        if (genre!="")
          BooksToGenre.new(:book_id=>@book.id,:genre_id=>genre.id).save
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
      BooksToGenre.where(book_id: @book.id).destroy_all
      params[:book][:genres].each do |genre|
        if (genre!="")
          BooksToGenre.new(:book_id=>@book.id,:genre_id=>genre).save
        end
      end
      redirect_to @book, :notice => "The book has been updated."
    else
      render 'edit'
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path, :notice => "The book has been deleted."
  end

  def add_to_list
      if request.post?
      @book = Book.find(params[:id])
      @ub = UsersToBook.new(:book_id=>@book.id,:user_id=>current_user.id,:rating_id=>params[:rating],:shelf_id=>params[:shelves])
      if @ub.valid?
        @ub.save
      @ub.create_activity(:added_book, :owner => current_user)
      end
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
