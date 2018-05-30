class CreateReccomandations < ActiveRecord::Migration[5.1]
  def change
    create_table :recommandations do |t|
      t.references :first_book
      t.references :second_book
      t.references :user, foreign_key: true
      t.timestamps

    end
  end
end
