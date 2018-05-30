class Recommandation < ApplicationRecord
  belongs_to :first_book, class_name: 'Book'
  belongs_to :second_book, class_name: 'Book'
  validates :first_book_id,uniqueness: { scope: [:user_id,:second_book_id] }
  validates_presence_of :user_id
  validates_presence_of :first_book_id
  validates_presence_of :second_book_id
  belongs_to :user
  include PublicActivity::Common

  before_destroy :delete_activities_now

  def delete_activities_now
    acts = PublicActivity::Activity.where(trackable_id: self.id, trackable_type: "Recommandation")
    acts.delete_all
  end


  def self.delete_activities(rid)
    acts = PublicActivity::Activity.where(trackable_id: rid, trackable_type: "Recommandation")
    acts.destroy_all
  end
end
