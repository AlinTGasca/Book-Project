class CreateAuthors < ActiveRecord::Migration[5.1]
  def change
    create_table :authors do |t|
      t.string :firstName
      t.string :lastName
      t.text :bios
      t.date :birth
      t.date :death

      t.timestamps
    end
  end
end
