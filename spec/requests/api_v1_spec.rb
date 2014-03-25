require 'spec_helper'
require 'active_record/fixtures'

describe 'APIV1' do
  fixtures :users, :days

  it 'Gets a token and creates a new day' do
    params = {email: 'robert@service.ca', password: '~~~REMOVED~~~'}
    post '/api/v1/tokens', params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.body).to include('token')
    body = JSON.parse(response.body)
    expect(response.status).to eq(200)
    @authentication_token = body['token']

    lambda do
      params = {at: @authentication_token, day: {date: '2013-11-18', content: 'hello'}}
      post '/api/v1/mobiles/addday', params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response.status == 200)
    end.should change(Day, :count).by(1)
  end

  it 'Try to create a new day with an invalid token' do
    @authentication_token = 'garbagetoken'
    lambda do
      params = {at: @authentication_token, day: {date: '2013-11-18', content: 'hello'}}
      post '/api/v1/mobiles/addday', params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response.status == 401)
    end.should_not change(Day, :count)
  end

  it 'Gets a token and edit a day' do
    params = {email: 'robert@service.ca', password: '~~~REMOVED~~~'}
    post '/api/v1/tokens', params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.body).to include('token')
    body = JSON.parse(response.body)
    expect(response.status).to eq(200)
    @authentication_token = body['token']

    params = {at: @authentication_token, day: {content: 'hello. test.', date: '2013-11-17', rails_id: 1, updated_at: '2014-01-10 04:46:37.433502'}}
    post '/api/v1/mobiles/editday', params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(200)
    body = JSON.parse(response.body)
    expect(body['day']['content']).to include('test')
  end

  it 'Try to edit a day using an invalid token' do
    @authentication_token = 'garbagetoken'
    params = {at: @authentication_token, day: {content: 'hello. test.', date: '2013-11-17', rails_id: 1, updated_at: '2014-01-10 04:46:37.433502'}}
    post '/api/v1/mobiles/editday', params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(401)
  end

  it 'Gets a token and tries to create a day that has an invalid date' do
    params = {email: 'robert@service.ca', password: '~~~REMOVED~~~'}
    post '/api/v1/tokens', params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.body).to include('token')
    body = JSON.parse(response.body)
    expect(response.status).to eq(200)
    @authentication_token = body['token']

    params = {at: @authentication_token, day: {date: '(Choose date)-->', content: 'hello'}}

    post '/api/v1/mobiles/addday', params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status).to eq(422)
  end

  it 'Gets a token and tries to update the gcm regid' do
    params = {email: 'robert@service.ca', password: '~~~REMOVED~~~'}
    post '/api/v1/tokens', params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.body).to include('token')
    body = JSON.parse(response.body)
    expect(response.status).to eq(200)
    @authentication_token = body['token']
    @regid = '~~~REMOVED~~~'
    @requesting_user = User.where('authentication_token = ?', BCrypt::Engine.hash_secret(@authentication_token, ENV["SALT"])).first #todo: access bcrypt_token function instead
    params = {at: @authentication_token, regid: @regid}
    post '/api/v1/mobiles/gcmregid', params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status == 200)
    expect(@requesting_user.regid == @regid)
  end

  it 'Try to update the gcm regid with an invalid token' do
    @authentication_token = 'garbagetoken'
    @regid = '~~~REMOVED~~~'
    params = {at: @authentication_token, regid: @regid}
    post '/api/v1/mobiles/gcmregid', params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
    expect(response.status == 401)
  end
end

