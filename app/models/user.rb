class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lastseenable
  validates_presence_of :username
  validates_uniqueness_of :username
  has_many :users_to_books, dependent: :destroy
  has_many :books, through: :users_to_books
  has_many :reviews, dependent: :destroy
  has_many :recommandations, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>",friend: "80x80", mini: "30x30>"}, default_url: "/images/:style/No_Image_Available.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  acts_as_voter
  has_many :comments, as: :commentable, dependent: :destroy
  has_friendship
  validates_length_of :username, :maximum => 20
  include PublicActivity::Common


  def self.find_by_uid!(uid)

    if User.exists?(:username => uid)
      User.find_by(:username => uid)
    else
      User.find(uid)
    end

  end

  GENDER_TYPES = ["Unspecified","Male", "Female"]


  def country_name
    country = self.country
    ISO3166::Country[country]
  end

end
