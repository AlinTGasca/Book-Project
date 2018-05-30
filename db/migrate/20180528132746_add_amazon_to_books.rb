class AddAmazonToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :amazon, :string
  end
end
