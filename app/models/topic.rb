class Topic < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :comments, as: :commentable, dependent: :destroy
  validates_presence_of :title
  validates_presence_of :body
  validates_presence_of :user_id
  validates_presence_of :category_id
  acts_as_votable
  include PublicActivity::Common

  def self.last_post(tid)
    _topic = Topic.find(tid)
    if _topic.comments.last
      return _topic.comments.last
      else return _topic
    end
  end


  def self.delete_activities(cid)
    acts = PublicActivity::Activity.where(trackable_id: cid, trackable_type: "Topic")
    acts.destroy_all
  end
end
