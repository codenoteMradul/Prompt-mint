class User < ApplicationRecord
  has_secure_password

  has_many :bundles, dependent: :destroy
  has_many :purchases, dependent: :destroy

  before_validation :normalize_email
  before_validation :normalize_phone

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :phone, presence: true, format: { with: /\A\d+\z/, message: "must contain only numbers" }

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end

  def normalize_phone
    self.phone = phone.to_s.strip
  end
end
