class Conversation < ApplicationRecord
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :receiver, class_name: "User", foreign_key: "receiver_id"
  has_many :messages, dependent: :destroy

  validates_uniqueness_of :sender_id, scope: :receiver_id


  scope :between, -> (sender_id,receiver_id) do
    where("(conversations.sender_id = ? AND conversations.receiver_id = ?) OR (conversations.receiver_id = ? AND conversations.sender_id = ?)", sender_id, receiver_id, sender_id, receiver_id)
  end

  def unread_message_count(current_user)
    self.messages.where("user_id != ? AND read = ?", current_user.id, false).count
  end

  def self.unread_messages(uid)
    user = User.find(uid);
    convs = Conversation.where("sender_id = ? OR receiver_id = ?", user.id, user.id)
    sum = 0;
    convs.each do |conv|
      sum = sum + conv.unread_message_count(user)
    end
    return sum;
  end
end