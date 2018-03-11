class Shelf < ApplicationRecord
  has_many :users_to_books
  validates_presence_of :status
end
