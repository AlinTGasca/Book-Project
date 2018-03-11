class Create < ActiveRecord::Migration[5.1]
  def change
    create_table :shelves do |t|
      t.string :status

      t.timestamps
    end
  end
end
