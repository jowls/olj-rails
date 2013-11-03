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
  private
  def restrict_access
    devise_token = params[:at]
    salted_token =  devise_token + 'jlon' #jlon is the salt
    token = BCrypt::Password.create(salted_token)
    @valid_user = User.where("authentication_token = ?",token).first
    head :unauthorized unless @valid_user
  end
end