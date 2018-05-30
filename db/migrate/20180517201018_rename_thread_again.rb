class RenameThreadAgain < ActiveRecord::Migration[5.1]
  def change
    rename_table :threads, :topics
  end
end
