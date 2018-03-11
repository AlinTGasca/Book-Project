class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_presence_of :username
  validates_uniqueness_of :username
  has_many :users_to_books
  has_many :books, through: :users_to_books
  has_many :reviews
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/No_Image_Available.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  acts_as_voter

  def self.find_by_uid!(uid)
    User.find_by!("username = :p OR id = :p", p: uid)
  end


end
