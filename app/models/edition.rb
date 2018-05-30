class Edition < ApplicationRecord
  belongs_to :book
  validates_presence_of :book_id, :title
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/No_Image_Available.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/


  def country_name
    country = self.country
    ISO3166::Country[country]
  end
end
