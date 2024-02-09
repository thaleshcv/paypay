class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :categories, inverse_of: :user
  has_many :entries, inverse_of: :user
  has_many :billings, inverse_of: :user

  def nick_name
    email.split("@").first
  end
end
