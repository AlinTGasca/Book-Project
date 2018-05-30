class Author < ApplicationRecord
  validates :lastName, presence: true
  has_many :books_to_authors, dependent: :destroy
  has_many :books, through: :books_to_authors
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>",mini: "30x30>" }, default_url: "/images/:style/No_Image_Available.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  has_many :comments, as: :commentable, dependent: :destroy
  include PublicActivity::Common

  GENDER_TYPES = ["Unspecified","Male", "Female"]


  def country_name
    country = self.country
    ISO3166::Country[country]
  end
end
