class Book < ApplicationRecord
  validates :title, presence: true
  has_many :books_to_authors, dependent: :destroy
  has_many :authors, through: :books_to_authors
  has_many :books_to_genres, dependent: :destroy
  has_many :genres, through: :books_to_genres
  has_many :users_to_books, dependent: :destroy
  has_many :users, through: :users_to_books
  has_many :reviews, dependent: :destroy
  has_many :editions, dependent: :destroy
  has_many :books, through: :first_books, source: :recommandation
  has_many :first_books, source: :recommandation
  has_many :books, through: :second_books, source: :recommandation
  has_many :second_books, source: :recommandation
  has_many :recommandations , dependent: :destroy, foreign_key: :first_book_id
  has_many :recommandations , dependent: :destroy, foreign_key: :second_book_id
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>",mini: "30x30>" }, default_url: "/images/:style/No_Image_Available.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  has_many :comments, as: :commentable, dependent: :delete_all
  include PublicActivity::Common

  def self.score(bid)
  _avg_rat = 0
  _ratings_given = UsersToBook.joins(:book,:rating,:shelf).where(book_id: bid).where.not(ratings: { score: nil }, shelves: {status: 'Plan to Read'}).select("ratings.score")
  _ratings_given.each do |rating|
    _avg_rat = _avg_rat + rating.score
  end
  _avg_rat = _avg_rat.to_f/_ratings_given.size
  if !_avg_rat.nan?
    return _avg_rat
    else return 0.0
  end
  end
  
end
