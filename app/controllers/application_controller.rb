class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  # This is our new function that comes before Devise's one
  #before_filter :authenticate_user_from_token!
  # This is Devise's authentication
  before_filter :authenticate_user!

  #def after_sign_up_path_for(resource)
  #  '/finish'
  #end

  #def after_sign_in_path_for(resource)
  #  '/journal'
  #end

  private
  # For this example, we are simply using token authentication
  # via parameters. However, anyone could use Rails's token
  # authentication features to get the token from a header.
  def authenticate_user_from_token!
    user_token = params[:user_token].presence
    salted_token = user_token && BCrypt::Password.create(user_token + 'jlon')
    user = salted_token && User.find_by_authentication_token(salted_token)

    if user
# Notice we are passing store false, so the user is not
# actually stored in the session and a token is needed
# for every request. If you want the token to work as a
# sign in token, you can simply remove store: false.
      sign_in user, store: false
    end
  end
end
