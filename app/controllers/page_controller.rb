class PageController < ApplicationController
  protect_from_forgery :except => [:begin_user_onboard]#http://stackoverflow.com/questions/1177863/how-do-i-ignore-the-authenticity-token-for-specific-actions-in-rails
  skip_before_filter :authenticate_user!
  #skip_before_filter :authenticate_user_from_token!
  def index
  end
  def about
  end
  def inspiration

  end
  def poll
  end
  def begin_user_onboard
    session["day"] = params[:startDay]
    redirect_to('/users/sign_up')
  end
end