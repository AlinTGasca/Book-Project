class CreateDropShekfs < ActiveRecord::Migration[5.1]
  def change
    drop_table :shelf
  end
end
