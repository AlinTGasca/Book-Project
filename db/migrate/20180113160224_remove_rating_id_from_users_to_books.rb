class RemoveRatingIdFromUsersToBooks < ActiveRecord::Migration[5.1]
  def change
    remove_column :users_to_books, :rating_id
  end
end
