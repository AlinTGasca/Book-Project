class AddThingsForList < ActiveRecord::Migration[5.1]
  def change
    add_column :users_to_books, :start_reading, :date
    add_column :users_to_books, :end_reading, :date
    add_column :users_to_books, :notes, :string
  end
end
