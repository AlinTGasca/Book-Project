class RecommandationsController < ApplicationController
def new
  @rec = Recommandation.new
  @book = Book.find(params[:book_id])
  _not_books = Recommandation.where(first_book_id: @book.id, user_id: current_user.id).pluck(:second_book_id);
  @books = Book.where.not(id: _not_books<<(@book.id))
end


def create
  @rec = Recommandation.new(:first_book_id=>params[:book_id],:second_book_id=>params[:recommandation],:user_id=>current_user.id)
  @book = Book.find(params[:book_id])
  _not_books = Recommandation.where(first_book_id: @book.id, user_id: current_user.id).pluck(:second_book_id);
  @books = Book.where.not(id: _not_books<<(@book.id))
  if @rec.valid?
    @rec2 = Recommandation.new(:first_book_id=>params[:recommandation],:second_book_id=>params[:book_id],:user_id=>current_user.id)
    if @rec2.valid?
    @rec.save
    @rec2.save
    @rec.create_activity(:recommandation, :owner => current_user)
    redirect_to book_path(params[:book_id]), notice: 'Your recommendation has been added.'
  else
    render 'new'
    end
    else render 'new'
    end
end

  def destroy
    _rec = Recommandation.find(params[:id])
    _first = _rec.first_book_id
    _second = _rec.second_book_id
    Recommandation.where(first_book_id: _first, second_book_id: _second, user_id: current_user.id).destroy_all
    Recommandation.where(first_book_id: _second, second_book_id: _first, user_id: current_user.id).destroy_all
    redirect_to book_recommandations_path(_rec.first_book_id), notice: 'Your recommendation has been removed.'
  end


  end