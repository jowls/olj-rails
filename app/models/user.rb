class User < ActiveRecord::Base
  #after_create :add_user
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :days
  #before_save :ensure_authentication_token

  require 'bcrypt'

  def ensure_authentication_token
    if authentication_token.blank?
      generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      devise_token = Devise.friendly_token
      #self.salt = BCrypt::Engine.generate_salt
      #salted_token =  devise_token + 'jlon' #jlon is the salt
      #token = BCrypt::Password.create(salted_token)
      token = BCrypt::Engine.hash_secret(devise_token, ENV["SALT"])
      self.authentication_token = token
      break devise_token unless User.where(authentication_token: token).first
    end
  end
end
