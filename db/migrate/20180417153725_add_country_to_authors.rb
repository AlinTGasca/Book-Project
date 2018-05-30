class AddCountryToAuthors < ActiveRecord::Migration[5.1]
  def change
    add_column :authors, :country, :string, default: false
  end
end
