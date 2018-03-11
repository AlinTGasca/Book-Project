class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :rating
  validates_presence_of :user_id, :book_id, :rating_id, :content
  validates :book_id,uniqueness: { scope: [:user_id] }
  acts_as_votable
end
