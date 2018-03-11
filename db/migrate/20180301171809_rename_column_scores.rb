class RenameColumnScores < ActiveRecord::Migration[5.1]
  def change
    rename_column :reviews, :score_id, :rating_id
  end
end
