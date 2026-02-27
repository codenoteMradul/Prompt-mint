class Message < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  validates :body, presence: true, length: { maximum: 2000 }
  validate :cannot_message_self

  after_create_commit :broadcast_to_conversation

  scope :between, ->(user_a_id, user_b_id) do
    where(sender_id: user_a_id, recipient_id: user_b_id)
      .or(where(sender_id: user_b_id, recipient_id: user_a_id))
  end

  def self.stream_for(viewer_id, other_id)
    "conversation:#{viewer_id}:#{other_id}"
  end

  private

  def broadcast_to_conversation
    broadcast_append_to(
      self.class.stream_for(sender_id, recipient_id),
      target: "messages",
      partial: "messages/message",
      locals: { message: self, viewer_id: sender_id }
    )

    broadcast_append_to(
      self.class.stream_for(recipient_id, sender_id),
      target: "messages",
      partial: "messages/message",
      locals: { message: self, viewer_id: recipient_id }
    )
  end

  def cannot_message_self
    return if sender_id.blank? || recipient_id.blank?
    return unless sender_id == recipient_id

    errors.add(:base, "You cannot message yourself.")
  end
end
