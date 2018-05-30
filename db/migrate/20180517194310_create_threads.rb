class CreateThreads < ActiveRecord::Migration[5.1]
  def change
    create_table :threads do |t|
      t.string :title
      t.string :body
      t.references  :category, index: true
      t.references  :user, index: true
      t.timestamps
    end
  end
end
