class CreateBooksToAuthors < ActiveRecord::Migration[5.1]
  def change
    create_table :books_to_authors do |t|
      t.belongs_to :author, index: true
      t.belongs_to :book, index: true
      t.timestamps
    end
  end
end
