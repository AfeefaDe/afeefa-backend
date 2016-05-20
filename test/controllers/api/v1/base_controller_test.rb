require 'test_helper'

class Api::V1::BaseControllerTest < ActionController::TestCase

  should 'have a ping method' do
    Timecop.freeze(Time.now) do
      set_auth_header
      get :ping
      assert_response 200
      expected = {
          pong: Time.now
      }.to_json
      assert_equal expected, response.body
    end
  end

  context 'token as params allowed' do

    setup do
      Settings.api.stubs(:allow_token_as_param).returns(true)
    end

    should 'authenticate by http header' do
      get :ping
      assert_response 401

      set_auth_header('0815')
      get :ping
      assert_response 401

      set_auth_header
      get :ping
      assert_response 200
    end

    should 'authenticate by token as param' do
      get :ping
      assert_response 401

      get :ping, token: ''
      assert_response 401

      get :ping, token: '0815'
      assert_response 401

      get :ping, token: Settings.api.token
      assert_response 200
    end
  end

  context 'token as params not configured' do

    setup do
      Settings.api.stubs(:allow_token_as_param).returns(nil)
    end

    should 'authenticate by http header' do
      get :ping
      assert_response 401

      set_auth_header('0815')
      get :ping
      assert_response 401

      set_auth_header
      get :ping
      assert_response 200
    end

    should 'authenticate by token as param' do
      get :ping
      assert_response 401

      get :ping, token: ''
      assert_response 401

      get :ping, token: '0815'
      assert_response 401

      get :ping, token: Settings.api.token
      assert_response 401
    end
  end

  context 'token as params not allowed' do

    setup do
      Settings.api.stubs(:allow_token_as_param).returns(false)
    end

    should 'authenticate by http header' do
      get :ping
      assert_response 401

      set_auth_header('0815')
      get :ping
      assert_response 401

      set_auth_header
      get :ping
      assert_response 200
    end

    should 'authenticate by token as param' do
      get :ping
      assert_response 401

      get :ping, token: ''
      assert_response 401

      get :ping, token: '0815'
      assert_response 401

      get :ping, token: Settings.api.token
      assert_response 401
    end
  end

  private

  def set_auth_header(token = Settings.api.token)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(token)
  end

end
