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
    self.name = email.split("@").first unless email.blank?
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
end
