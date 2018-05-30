class Genre < ApplicationRecord
  has_many :books_to_genres
  has_many :genres, through: :books_to_genres
end
