class Category < ApplicationRecord
  has_many :topics, dependent: :destroy

  def self.last_post(cid)
    _topics = Topic.where(category_id: cid)
    _topics = _topics.sort{ |p1,p2| Topic.last_post(p2.id).created_at <=> Topic.last_post(p1.id).created_at }
    return _topics.first
  end

  def self.replies(cid)
    _topics = Topic.where(category_id: cid)
    _count = 0
    _topics.each do |topic|
      _count = _count + topic.comments.count
    end
    return _count
  end

end
