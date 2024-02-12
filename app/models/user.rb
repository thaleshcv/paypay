class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_one_attached :avatar
  has_many :categories, inverse_of: :user
  has_many :entries, inverse_of: :user
  has_many :billings, inverse_of: :user

  before_validation on: :create do
    self.name = email.split("@").first if name.blank? && email.present?
  end

  def nick_name
    name || email.split("@").first
  end

  def safe_avatar_url
    if avatar.attached?
      avatar
    else
      "https://robohash.org/#{Digest::MD5.hexdigest(email)}"
    end
  end

  # Similar tp +update_with_password+ provided by Devise.
  # The difference is that this will not delete +:password+ and +:password_confirmation+
  # keys from params.
  def full_update_with_password(params)
    current_password = params.delete(:current_password)

    result = if valid_password?(current_password)
      update(params)
    else
      assign_attributes(params)
      valid?
      errors.add(:current_password, current_password.blank? ? :blank : :invalid)
      false
    end

    clean_up_passwords
    result
  end
end
