class PageController < ApplicationController
  protect_from_forgery :except => [:begin_user_onboard] #http://stackoverflow.com/questions/1177863/how-do-i-ignore-the-authenticity-token-for-specific-actions-in-rails
  skip_before_filter :authenticate_user!
  #skip_before_filter :authenticate_user_from_token!
  def index
  end
  def about
  end
  def inspiration
  end

  def send_gcm
    destination = ["APA91bFsCrOdjTRs7YT3kxs7cidz6HYuX_NW8j_RrKFZXBKnA2mBmcrBuCiQ5ZVU6cHF49q2aXPTnrwDWx2mWXoPHRU0BVNxLiBaX4Pwbpf1WAlmE_t6wNor-CuXH5fsyF1X84EDP3mvouBhmfBYeVXKhKesRDQBrnN1jphv73oy9J4G7i2Q27c"]
    # can be an string or an array of strings containing the regIds of the devices you want to send

    data = {:message => "You didn't write anything yesterday. Tell us what you did?", :title => "One Line Journal"}
    # must be an hash with all values you want inside you notification

    GCM.send_notification( destination, data )
    # Notification with custom information

    #GCM.send_notification( destination, data, :collapse_key => "placar_score_global", :time_to_live => 3600, :delay_while_idle => false )
    # Notification with custom information and parameters
    redirect_to('/users/sign_up')
  end

  def poll
  end
  def begin_user_onboard
    session["day"] = params[:startDay]
    redirect_to('/users/sign_up')
  end
end