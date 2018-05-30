class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  validates_presence_of :user_id, :body
  acts_as_votable
  include PublicActivity::Common



  def self.delete_activities(cid)
    acts = PublicActivity::Activity.where(trackable_id: cid, trackable_type: "Comment")
    acts.destroy_all
  end

end
