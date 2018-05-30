class SearchController < ApplicationController

  def search
    if params[:search_for] == 'Books'
      @genres = Genre.all.order(:name)
    if params[:search] == nil
      if Genre.exists?(params[:genre])
        @results = Book.includes(:genres).where(genres: {id: params[:genre]})
        else
      @results = Book.all
      end
    else
      if Genre.exists?(params[:genre])
        @results = Book.includes(:genres).where('title LIKE ?', "%#{params[:search]}%").where(genres: {id: params[:genre]})
        else
      @results = Book.where('title LIKE ?', "%#{params[:search]}%")
      end
    end
    if params[:sort]=='title'
    @results = @results.sort { |p1, p2| p1.title.upcase <=> p2.title.upcase}
    elsif params[:sort]=='title_inv'
    @results = @results.sort { |p1, p2| p2.title.upcase <=> p1.title.upcase}
    elsif params[:sort]=='published_inv'
    @results = @results.reject(&:published) + @results.select(&:published).sort_by(&:published)
    elsif params[:sort]=='published'
      @results = @results.select(&:published).sort_by {|x| Date.today - x.published} + @results.reject(&:published)
    elsif params[:sort]=='score_inv'
      @results = @results.sort{ |p1,p2| Book.score(p1.id) <=> Book.score(p2.id) }
    elsif params[:sort]=='score'
      @results = @results.sort{ |p1,p2| Book.score(p2.id) <=> Book.score(p1.id) }
    elsif params[:sort] == 'popularity'
      @results = @results.sort{ |p1,p2| UsersToBook.joins(:book).where(book_id: p2.id).count <=> UsersToBook.joins(:book).where(book_id: p1.id).count}
    elsif params[:sort] == 'popularity_inv'
      @results = @results.sort{ |p1,p2| UsersToBook.joins(:book).where(book_id: p1.id).count <=> UsersToBook.joins(:book).where(book_id: p2.id).count}
    end
    else
      if params[:search_for] == 'Authors'
        if params[:search] == nil
          @results = Author.all
        else
          @results = Author.where('firstName LIKE ? or lastName LIKE ?', "%#{params[:search]}%","%#{params[:search]}%")
        end
        if params[:sort]=='fname_inv'
          @results = @results.sort { |p1, p2| p1.firstName.upcase <=> p2.firstName.upcase }
        elsif params[:sort]=='fname'
          @results = @results.sort { |p1, p2| p2.firstName.upcase <=> p1.firstName.upcase }
          elsif params[:sort]=='lname_inv'
            @results = @results.sort { |p1, p2| p1.firstName.upcase <=> p2.firstName.upcase }
        elsif params[:sort]=='lname'
          @results = @results.sort { |p1, p2| p2.firstName.upcase <=> p1.firstName.upcase }
        elsif params[:sort]=='birth_inv'
          @results = @results.reject(&:birth) + @results.select(&:birth).sort_by(&:birth)
        elsif params[:sort]=='birth'
          @results = @results.select(&:birth).sort_by {|x| Date.today - x.birth} + @results.reject(&:birth)
          end
          else if params[:search_for] == 'Users'
          if params[:search] == nil
            @results = User.all
          else
            @results = User.where('username LIKE ?', "%#{params[:search]}%")
          end
          if params[:sort]=='uname_inv'
            @results = @results.sort { |p1, p2| p1.username.upcase <=> p2.username.upcase }
          elsif params[:sort]=='uname'
            @results = @results.sort { |p1, p2| p2.username.upcase <=> p1.username.upcase }
          elsif params[:sort]=='join_inv'
            @results = @results.reject(&:created_at) + @results.select(&:created_at).sort_by(&:created_at)
          elsif params[:sort]=='join'
            @results = @results.select(&:created_at).sort_by {|x|
              if x.created_at
                DateTime.current - x.created_at.to_datetime
              end} + @results.reject(&:created_at)
          elsif params[:sort]=='last_sign_inv'
            @results = @results.reject(&:last_seen) + @results.select(&:last_seen).sort_by(&:last_seen)
          elsif params[:sort]=='last_sign'
            @results = @results.select(&:last_seen).sort_by {|x|  if x.last_seen
                                                                             DateTime.current - x.last_seen.to_datetime
                                                                           end} + @results.reject(&:last_seen)
          elsif params[:sort]=='reviews_inv'
            @results = @results.sort { |p1,p2| Review.where(user_id: p1.id).count <=> Review.where(user_id: p2.id).count }
            elsif params[:sort]=='reviews'
              @results = @results.sort { |p1,p2| Review.where(user_id: p2.id).count <=> Review.where(user_id: p1.id).count }
          elsif params[:sort]=='reviewscore_inv'
            @results = @results.sort { |p1,p2| _reviews1 = Review.where(user_id: p1.id)
            _sum1 = 0
            _reviews1.each do |review|
              _sum1 = _sum1 + review.get_likes.size
              _sum1 = _sum1 - review.get_dislikes.size
            end
            _reviews2 = Review.where(user_id: p2.id)
            _sum2 = 0
            _reviews2.each do |review|
              _sum2 = _sum2 + review.get_likes.size
              _sum2 = _sum2 - review.get_dislikes.size
            end
            _sum1 <=> _sum2
            }
          elsif params[:sort]=='reviewscore'
            @results = @results.sort { |p1,p2| _reviews1 = Review.where(user_id: p1.id)
            _sum1 = 0
            _reviews1.each do |review|
              _sum1 = _sum1 + review.get_likes.size
              _sum1 = _sum1 - review.get_dislikes.size
            end
            _reviews2 = Review.where(user_id: p2.id)
            _sum2 = 0
            _reviews2.each do |review|
              _sum2 = _sum2 + review.get_likes.size
              _sum2 = _sum2 - review.get_dislikes.size
            end
            _sum2 <=> _sum1
            }
            elsif params[:sort]=='comments_inv'
            @results = @results.sort { |p1,p2| Review.where(user_id: p1.id).count <=> Review.where(user_id: p2.id).count }
          elsif params[:sort]=='comments'
            @results = @results.sort { |p1,p2| Review.where(user_id: p2.id).count <=> Review.where(user_id: p1.id).count }
          end
               end
        end

    end
    @results = @results.paginate(page: params[:page], per_page: 2)
  end



end
