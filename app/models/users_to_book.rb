class UsersToBook < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :rating
  belongs_to :shelf
  validates :book_id,uniqueness: { scope: [:user_id] }
  validates_presence_of :rating_id
  validates_presence_of :shelf_id
  include PublicActivity::Common




  def self.delete_activities(rid)
    acts = PublicActivity::Activity.where(trackable_id: rid, trackable_type: "UsersToBook")
    acts.destroy_all
  end
end
