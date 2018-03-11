class ShelfStatus < ActiveRecord::Migration[5.1]
  def change
    add_column :shelves, :status, :string
  end
end
