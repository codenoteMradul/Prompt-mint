class User < ApplicationRecord
  has_secure_password

  has_one_attached :avatar

  has_many :bundles, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :reviews_given, class_name: "Review", foreign_key: :reviewer_id, dependent: :destroy, inverse_of: :reviewer
  has_many :reviews_received, class_name: "Review", foreign_key: :seller_id, dependent: :destroy, inverse_of: :seller
  has_many :messages_sent, class_name: "Message", foreign_key: :sender_id, dependent: :destroy, inverse_of: :sender
  has_many :messages_received, class_name: "Message", foreign_key: :recipient_id, dependent: :destroy, inverse_of: :recipient

  before_validation :normalize_email
  before_validation :normalize_phone
  before_validation :normalize_country
  after_update_commit :recalculate_creator_ranks_if_needed

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :phone,
            presence: true,
            format: {
              with: /\A\d{7,15}\z/,
              message: "must contain only numbers (7–15 digits)"
            }
  validates :country, presence: true
  validates :years_of_experience, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :password, length: { minimum: 8 }, allow_nil: true
  validate :avatar_must_be_valid_image

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end

  def normalize_phone
    self.phone = phone.to_s.gsub(/\D+/, "")
  end

  def normalize_country
    self.country = country.to_s.strip
  end

  def avatar_must_be_valid_image
    return unless avatar.attached?

    unless avatar.content_type.to_s.start_with?("image/")
      errors.add(:avatar, "must be an image file")
    end

    if avatar.blob&.byte_size.to_i > 5.megabytes
      errors.add(:avatar, "must be smaller than 5MB")
    end
  end

  def recalculate_creator_ranks_if_needed
    return unless saved_change_to_years_of_experience?

    CreatorRankingService.recalculate_all!
  end
end
