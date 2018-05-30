class EditionsController < ApplicationController
  before_action :book_exist, only: [:new,:create]
  before_action :edition_exist, only: [:edit,:update,:destroy]

  def book_exist
    if not Book.exists?params[:book_id]
      redirect_to root_path, alert: 'The book does not exist. '
    end
  end

  def edition_exist
    if not Edition.exists?params[:edition_id]
      redirect_to root_path, alert: 'The edition does not exist.'
    end
  end

  def new
    if (current_user.try(:admin?))
    @edition = Edition.new
    @book = Book.find(params[:book_id])
    else redirect_to book_editions_path(@edition.book_id), :alert => "You don't have the rights to acces this page."
    end
  end


  def create
    @edition = Edition.new(:title=>params[:title],:pubslished=>params[:published],:book_id=>params[:book_id],:avatar=>params[:avatar],:pages=>params[:pages],:country=>params[:country],:publisher=>params[:publisher])
    @book = Book.find(params[:book_id])
    if @edition.valid?
      @edition.save
      redirect_to book_editions_path(params[:book_id]), notice: 'Your edition has been added.'
    else
      render 'new'
    end
  end

  def edit
    @edition = Edition.find(params[:edition_id])
    if (current_user.try(:admin?))
      @book = Book.find(@edition.book_id)
    else redirect_to book_editions_path(@edition.book_id), :alert => "You don't have the rights to acces this page."
    end
  end

  def update
    @edition = Edition.find(params[:edition_id])
    if (current_user.try(:admin?))
      @book = Book.find(@edition.book_id)
      if @edition.update(edition_params)
        redirect_to book_editions_path(@edition.book_id), :notice => "The edition has been updated."
      else
        render 'edit'
      end
    else redirect_to book_editions_path(@edition.book_id), :notice => "You don't have the rights to acces this page."
    end
  end

  def destroy
    @edition = Edition.find(params[:edition_id])
    if (current_user.try(:admin?))
      @edition.destroy
      redirect_to book_editions_path(@edition.book_id), :notice => "The edition has been removed from the book."
    else redirect_to book_editions_path(@edition.book_id), :alert => "You don't have the rights to acces this page."
    end
  end

  private
  def edition_params
    params.require(:edition).permit(:title,:pubslished, :avatar,:country,:publisher,:pages)
  end
end
