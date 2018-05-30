class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book
  belongs_to :rating
  validates_presence_of :user_id, :book_id, :rating_id, :content
  validates :book_id,uniqueness: { scope: [:user_id] }
  acts_as_votable
  include PublicActivity::Common

  before_destroy :delete_activities_now

  def delete_activities_now
    acts = PublicActivity::Activity.where(trackable_id: self.id, trackable_type: "Review")
    acts.delete_all
  end


  def self.delete_activities(rid)
    acts = PublicActivity::Activity.where(trackable_id: rid, trackable_type: "Review")
    acts.destroy_all
  end
end
