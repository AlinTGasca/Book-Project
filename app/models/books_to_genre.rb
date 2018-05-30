class BooksToGenre < ApplicationRecord
  belongs_to :genre
  belongs_to :book
  validates :book_id, uniqueness: { scope: [:genre_id] }
end
