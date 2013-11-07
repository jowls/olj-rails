class Api::V1::MobilesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!
  before_filter :restrict_access
  #protect_from_forgery :except => [:create, :show, :index]
  respond_to :json, :xml

  def index #wut?
    puts "Inside of index MobileController"
    #@requesting_user = User.where("authentication_token = '?'",params[:id])
    @requesting_user = User.find(params[:id])
    @mobile_days_index  = @requesting_user.days()
  end

  def show #Show users first map based on used id#
    puts "Inside of show MobileController"
    @requesting_user = User.find(params[:id])
    @mobile_days = @requesting_user.days().first
  end

  def create #Accept token and return list of days
    puts "Inside of create MobileController"
    @requesting_user = User.where("authentication_token = ?",params[:at]).first
    puts @requesting_user.email
    @mobile_days_index  = @requesting_user.days()
  end
  #curl --data '{"at": "4zwcfQZSPkGsLUHUyxhG", "day": {"date": "2013-11-17","content": "hello"}}' http://localhost:3000/api/v1/mobiles/addday --header "Accept: applicationer "Content-Type: application/json"

  def addday
    @at = params["at"]
    @token = bcrypt_token(@at)
    @requesting_user = User.where("authentication_token = ?",@token).first
    puts @requesting_user.email
    date_temp = params['day']['date']
    content_temp = params['day']['content']
    if !@requesting_user.nil?
      @newday = Day.new
      @newday.date = date_temp
      @newday.content = content_temp
      @newday.user_id = @requesting_user.id
      @newday.save    #todo: come back and catch dups, etc.
      @status = 'Shit looks good'
    end
  end

  private
  def restrict_access
    devise_token = params[:at]
    #salted_token =  devise_token + 'jlon' #jlon is the salt
    #token = BCrypt::Password.new(salted_token)
    token = BCrypt::Engine.hash_secret(devise_token, ENV["SALT"])
    @valid_user = User.where("authentication_token = ?",token).first
    head :unauthorized unless @valid_user
  end
  def bcrypt_token (in_token)
    BCrypt::Engine.hash_secret(in_token, ENV["SALT"])
  end

end