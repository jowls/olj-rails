class Api::V1::MobilesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :authenticate_user!
  before_filter :restrict_access
  #protect_from_forgery :except => [:create, :show, :index]
  respond_to :json, :xml
  #TODO: require 'date' Date.parse('2013-11-17')

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
  #curl --data '{"at": "4zwcfQZSPkGsLUHUyxhG", "day": {"date": "2013-11-17","content": "hello"}}' http://localhost:3000/api/v1/mobiles/addday --header "Accept: application/json" --header "Content-Type: application/json"

  def addday
    @at = params["at"]
    @token = bcrypt_token(@at)
    @requesting_user = User.where("authentication_token = ?",@token).first
    #puts @requesting_user.email
    date_temp = params['day']['date']
    content_temp = params['day']['content']
    if !@requesting_user.nil?
      @newday = Day.new
      @newday.date = date_temp
      @newday.content = content_temp
      @newday.user_id = @requesting_user.id
      unless @newday.save!
        head :unprocessable_entity
        @errors = @newday.errors.to_s
      end
    end
  end

  def alldays
    @at = params["at"]
    @token = bcrypt_token(@at)
    @requesting_user = User.where("authentication_token = ?",@token).first
    #puts @requesting_user.email
    if !@requesting_user.nil?
      @alldays = @requesting_user.days()
    end
  end
  #curl --data '{"at":"ZbE5fT_6Tb8sQbF6qdfQ", "day":{"content":"Bevs bd at supper. Crap veg chili. Awesome chicken wings. Test.", "date":"2014-01-01", "rails_d":167}}' http://localhost:3000/api/v1/mobiles/editday --header "Accept: application/json" --header "Content-Type: application/json"
  #TODO: not working yet but almost, need to ensure token is up to date, also watch out for commas in the content
  def editday
    @at = params['at']
    @rails_id = params['day']['rails_id']
    @android_updated_at = DateTime.parse(params['day']['updated_at'])
    @android_content = params['day']['content']
    @token = bcrypt_token(@at)
    @requesting_user = User.where('authentication_token = ?',@token).first
    #puts @requesting_user.email
    #puts @rails_id
    if !@requesting_user.nil?
      @day = Day.where('id = ?', @rails_id).first
      #puts @day.date
      #puts @day.id
      rails_updated = @day.date #this is where shit is fucking up
      android_updated  = @android_updated_at
      #puts (rails_updated <= android_updated).to_s + ' is the result of the datetime comparison.'
      #puts (@requesting_user.id == @day.user_id).to_s + ' is the result of the ID comparison.'
      if (rails_updated <= android_updated) && !@day.nil? && (@requesting_user.id == @day.user_id) #TODO: break this out to give better error messages
        @day.content = @android_content
        unless @day.save
          head :unprocessable_entity
          @errors = @newday.errors.to_s
        end
      else
        head :unprocessable_entity
        @errors = "Day has been updated more recently online. Please refresh journal before editing this day."
      end
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