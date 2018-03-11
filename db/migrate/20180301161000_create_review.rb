class CreateReview < ActiveRecord::Migration[5.1]
  def change
    create_table :reviews do |t|
      t.text :content
      t.belongs_to :score, index: true
      t.timestamps
    end
  end
end
