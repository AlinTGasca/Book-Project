class Book < ApplicationRecord
  validates :title, presence: true
  has_many :books_to_authors
  has_many :authors, through: :books_to_authors
  has_many :users_to_books
  has_many :users, through: :users_to_books
  has_many :reviews
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/No_Image_Available.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

end
