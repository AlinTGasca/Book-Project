class AddAvatarEdition < ActiveRecord::Migration[5.1]
  def change
    add_attachment :editions, :avatar
  end
end
