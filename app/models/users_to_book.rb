class UsersToBook < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :rating
  belongs_to :shelf
  validates :book_id,uniqueness: { scope: [:user_id] }
  validates_presence_of :rating_id
  validates_presence_of :shelf_id
end
