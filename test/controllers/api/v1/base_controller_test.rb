require 'test_helper'
require "#{Rails.root}/app/controllers/api/v1/exceptions"

class Api::V1::BaseControllerTest < ActionController::TestCase

  should 'fail for wrong host' do
    ActionController::TestRequest.any_instance.stubs(:host).returns('dummy-host')
    get :ping
    assert_response 401
    assert_equal 'wrong host: dummy-host, allowed: test.host', response.body
  end

  should 'fail for wrong protocol' do
    ActionController::TestRequest.any_instance.stubs(:protocol).returns('https')
    get :ping
    assert_response 401
    assert_equal 'wrong protocol: https, allowed: http', response.body
  end

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

  should 'trigger airbrake_test method only for valid admin_secret' do
    set_auth_header
    assert_raise Api::V1::TestAirbrakeException do
      get :test_airbrake, admin_secret: '0815'
    end

    get :test_airbrake, admin_secret: 'abc'
    assert_response 403

    get :test_airbrake, admin_secret: ''
    assert_response 403

    get :test_airbrake
    assert_response 403
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
      assert_equal 'auth failed', response.body

      get :ping, token: '0815'
      assert_response 401
      assert_equal 'auth failed', response.body

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
