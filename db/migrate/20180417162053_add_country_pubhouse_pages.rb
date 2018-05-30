class AddCountryPubhousePages < ActiveRecord::Migration[5.1]
  def change
    add_column :editions, :country, :string, default: false
    add_column :editions, :publisher, :string
    add_column :editions, :pages, :number
  end
end
