class User < ActiveRecord::Base
  #after_create :add_user
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :days

  require 'bcrypt'

  def ensure_authentication_token
    if authentication_token.blank?
      generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      devise_token = Devise.friendly_token
      token = BCrypt::Engine.hash_secret(devise_token, ENV["SALT"])
      self.authentication_token = token
      break devise_token unless User.where(authentication_token: token).first
    end
  end

  #http://stackoverflow.com/questions/6216969/how-to-implement-rufus-scheduler-in-rails
  def self.send_daily_push
    logger.info 'Started rufus task send_daily_push.'
    day_seconds = 24 * 60 * 60
    oneday_s = (48 + 16) * 60 * 60
    threeday_s = (96 + 16) * 60 * 60
    week_hrs_s = (192 + 16) * 60 * 60
    fifteen_min_s = 15 * 60
    User.all.each do |user|
      unless user.regid.nil?
        recent_day = nil
        user.days.each do |day|
          if recent_day.nil? or day.date > recent_day.date
            recent_day  = day
          end
        end
        unless recent_day.nil?
          now = DateTime.now
          zone = TZInfo::Timezone.get(user.tz)
          most_recent = DateTime.parse(recent_day.date.to_s)
          now_corrected = now.in_time_zone(zone).time
          diff = now_corrected - most_recent
          elapsed_seconds = (diff * day_seconds).to_i
          logger.info 'Elapsed seconds: ' + elapsed_seconds.to_s + ' for user with regid: ' + user.regid
          if (elapsed_seconds - oneday_s).abs < fifteen_min_s
            destination = user.regid
            logger.info 'Sending 1day reminder to ' + destination
            # can be an string or an array of strings  > (40*)containing the regIds of the devices you want to send
            data = {:message => "You didn't write anything yesterday. Tell us what you did?", :title => 'One Line Journal'}
            # must be an hash with all values you want inside you notification
            GCM.send_notification( destination, data )
          end
          if (elapsed_seconds - threeday_s).abs < fifteen_min_s
            destination = user.regid
            logger.info 'Sending 3day reminder to ' + destination
            data = {:message => 'Last entry was three day ago. Want to update your journal now?', :title => 'One Line Journal'}
            GCM.send_notification( destination, data )
          end
          if (elapsed_seconds - week_hrs_s).abs < fifteen_min_s
            destination = user.regid
            logger.info 'Sending 7day reminder to ' + destination
            data = {:message => 'This past week is empty. Want to update your journal?', :title => 'One Line Journal'}
            GCM.send_notification( destination, data )
          end
        end
      end
    end
    logger.info 'Finished rufus task send_daily_push.'
  end
end