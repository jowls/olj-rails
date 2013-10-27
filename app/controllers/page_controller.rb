class PageController < ApplicationController
  protect_from_forgery :except => [:begin_user_onboard]    #http://stackoverflow.com/questions/1177863/how-do-i-ignore-the-authenticity-token-for-specific-actions-in-rails
  def index
  end
  def about
  end
  def begin_user_onboard
    session["day"] = params[:startDay]
    redirect_to('/users/sign_up')
  end
end