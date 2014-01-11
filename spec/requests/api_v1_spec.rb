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

  it 'Gets a token and edit a day' do
    #puts "right now there are# days " + Day.count().to_s
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
    #puts response.body
    expect(body['day']['content']).to include('test')
  end
end