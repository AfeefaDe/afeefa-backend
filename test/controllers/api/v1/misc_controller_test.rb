require 'test_helper'
#TODO: autoload
require "#{Rails.root}/app/controllers/exceptions/api/controllers_api_exceptions"

class Api::V1::MiscControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    stub_current_user
  end

  should 'fail for wrong host' do
    ActionController::TestRequest.any_instance.stubs(:host).returns('dummy-host')
    get :ping
    assert_response :unauthorized
    assert_equal 'wrong host: dummy-host, allowed: test.host', response.body
  end

  should 'fail for wrong protocol' do
    ActionController::TestRequest.any_instance.stubs(:protocol).returns('https')
    get :ping
    assert_response :unauthorized
    assert_equal 'wrong protocol: https, allowed: http', response.body
  end

  should 'have a ping method' do
    Timecop.freeze(Time.now) do
      get :ping
      assert_response :success
      assert_equal({ pong: Time.current.to_s }.to_json, response.body)
    end
  end

  should 'trigger airbrake_test method only for valid admin_secret' do
    assert_raise Api::TestAirbrakeException do
      get :test_airbrake, admin_secret: '0815'
      assert_response :error
    end

    get :test_airbrake, admin_secret: 'abc'
    assert_response :forbidden

    get :test_airbrake, admin_secret: ''
    assert_response :forbidden

    get :test_airbrake
    assert_response :forbidden
  end

  should 'authenticate the user' do
    # TODO: replace with default method which requires login
    assert_raise Api::TestAirbrakeException do
      get :test_airbrake, admin_secret: '0815'
      assert_response :error
      assert user_signed_in = assign(:current_user)
      assert_equal user, user_signed_in
    end

    unstub_current_user

    get :test_airbrake
    assert_response :forbidden

  end

  should 'not authenticate the user for ping' do
    get :ping
    assert_response :success
  end

end
