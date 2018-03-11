class AddAuthorPicture < ActiveRecord::Migration[5.1]
  def change
    add_attachment :authors, :avatar
  end
end
