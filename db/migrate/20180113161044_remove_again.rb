class RemoveAgain < ActiveRecord::Migration[5.1]
  def change
        remove_column :users_to_books, :books_id
  end
end
