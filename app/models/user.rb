class User < ApplicationRecord
  has_secure_password

  has_many :bundles, dependent: :destroy
  has_many :purchases, dependent: :destroy

  before_validation :normalize_email
  before_validation :normalize_phone
  before_validation :normalize_country

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :phone, presence: true, format: { with: /\A\d+\z/, message: "must contain only numbers" }
  validates :country, presence: true
  validates :years_of_experience, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :password, length: { minimum: 8 }, allow_nil: true

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end

  def normalize_phone
    self.phone = phone.to_s.strip
  end

  def normalize_country
    self.country = country.to_s.strip
  end
end
