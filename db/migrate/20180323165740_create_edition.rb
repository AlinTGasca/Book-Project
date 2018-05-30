class CreateEdition < ActiveRecord::Migration[5.1]
  def change
    create_table :editions do |t|
      t.string :title
      t.date :pubslished
      t.references :book, foreign_key: true
      t.timestamps
    end
  end
end
