# app/controllers/registrations_controller.rb
class RegistrationsController < Devise::RegistrationsController
  #before_filter :authenticate_user!
  #after_filter :add_user
  after_filter :add_user, :only => :create

  def new
    @user_day = session['day']
    super
  end

  def create
    #if !session['day'].nil?
    #
    #  @day = Day.create(:date => Day.new, :content => session['day'], :user_id => current_user )
    #  @day.save
    #end
    @user_day = session['day']
    #@user = current_user.id
    super
  end

  def update
    super
  end

  protected

  def add_user
    @user = resource.id
    @day = Day.new(:date => Date.today, :content => session['day'], :user_id => @user)
    @day.save
    @garbage = nil
  end
end