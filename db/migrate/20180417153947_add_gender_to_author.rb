class AddGenderToAuthor < ActiveRecord::Migration[5.1]
  def change
    add_column :authors, :gender, :string
  end
end
