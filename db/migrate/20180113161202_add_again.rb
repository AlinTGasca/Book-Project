class AddAgain < ActiveRecord::Migration[5.1]
  def change
    add_reference :users_to_books, :rating, foreign_key: true
  end
end
