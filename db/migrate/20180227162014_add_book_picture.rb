class AddBookPicture < ActiveRecord::Migration[5.1]
  def change
    add_attachment :books, :avatar
  end
end
