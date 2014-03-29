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
  #http://stackoverflow.com/questions/6216969/how-to-implement-rufus-scheduler-in-rails
  def self.send_daily_push
    User.all.each do |user|
      unless user.regid.nil?
        @recent_day = nil
        user.days.each do |day|
          if @recent_day.nil? or day.date > @recent_day.date
            @recent_day  = day
          end
        end
        unless @recent_day.nil?
          @now = DateTime.now
          @most_recent = DateTime.parse(@recent_day.date.to_s)
          @diff = @now - @most_recent
          @elapsed_seconds = (@diff * 24 * 60 * 60).to_i
          if @elapsed_seconds > 86400
            destination = user.regid
            # can be an string or an array of strings containing the regIds of the devices you want to send
            data = {:message => "You didn't write anything yesterday. Tell us what you did?", :title => "One Line Journal"}
            # must be an hash with all values you want inside you notification
            GCM.send_notification( destination, data )
          end
        end
      end
    end
  end
end