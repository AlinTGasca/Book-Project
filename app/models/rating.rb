class Rating < ApplicationRecord
  has_many :users_to_books
  has_many :reviews
end
