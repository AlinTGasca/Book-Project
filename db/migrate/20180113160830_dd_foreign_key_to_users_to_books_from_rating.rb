class DdForeignKeyToUsersToBooksFromRating < ActiveRecord::Migration[5.1]
  def change
    add_reference :users_to_books, :ratings, foreign_key: true
  end
end
