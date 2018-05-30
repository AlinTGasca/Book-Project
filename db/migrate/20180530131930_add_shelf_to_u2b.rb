class AddShelfToU2b < ActiveRecord::Migration[5.1]
    def change
      add_reference :users_to_books, :shelf, foreign_key: true
    end
end
