class PageController < ApplicationController
  def index
  end
  def begin_user_onboard
    session["day"] = params[:startDay]
    redirect_to('/users/sign_up')
  end
end