class SearchController < ApplicationController

  def search
    if params[:search_for] == 'Books'
    if params[:search] == nil
      @results = Book.all
    else
      @results = Book.where('title LIKE ?', "%#{params[:search]}%")
    end
    else
      if params[:search_for] == 'Authors'
        if params[:search] == nil
          @results = Author.all
        else
          @results = Author.where('firstName LIKE ? or lastName LIKE ?', "%#{params[:search]}%","%#{params[:search]}%")
          end
          else
          if params[:search] == nil
            @results = User.all
          else
            @results = User.where('username LIKE ?', "%#{params[:search]}%")
          end
        end

      end
    end

end
