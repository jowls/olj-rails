=begin
#todo: this is copypasta from random places on the internet, never worked

require 'spec_helper'

describe Api::V1::MobilesController do
  render_views # if you have RABL views
  authentication_token = 'INIT'

  before do
    controller =
    post '/api/v1/mobiles/create', {email: 'robert@service.ca', password: '~~~REMOVED~~~'}
    body = JSON.parse(response.body)
    authentication_token = body['token']
  end

  describe "POST to create day" do

    it "should change the number of days" do
      lambda do
        post :addday, :at => authentication_token, :day => {:date => '2013-11-17', :content => 'hello'}
      end.should change(Day, :count).by(1)
    end

=begin

    it "should be successful" do
      post :create, user: @user_attributes
      response.should be_success
    end

    it "should set @user" do
      post :create, user: @user_attributes
      assigns(:user).email.should == @user_attributes[:email]
    end

=end

    it "should return created user in json" do # depend on what you return in action
      post @day_attributes
      body = JSON.parse(response.body)
      body['date'].should == @day_attributes['2013-11-17']
    end
  end
end=end
