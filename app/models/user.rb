class User < ApplicationRecord
  has_secure_password

  has_many :prompts, dependent: :destroy
  has_many :purchases, dependent: :destroy

  before_validation :normalize_email

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end

