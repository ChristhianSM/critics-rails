class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,  omniauth_providers: %i[github twitter]
  # association
  has_many :critics, dependent: :destroy

  enum role: { admin: 0, regular: 1}

  # Omniauth
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.username = auth.info.nickname
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def email_required?
    false
  end
end