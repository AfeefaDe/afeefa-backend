require 'test_helper'
require "#{Rails.root}/app/controllers/api/v1/exceptions"

class Api::V1::BaseControllerTest < ActionController::TestCase
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
      expected = {
          pong: Time.now
      }.to_json
      assert_equal expected, response.body
    end
  end

  should 'trigger airbrake_test method only for valid admin_secret' do
    assert_raise Api::V1::TestAirbrakeException do
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
    assert_raise Api::V1::TestAirbrakeException do
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

  private

  def stub_current_user(user: create(:user))
    @controller.class.any_instance.stubs(:set_user_by_token).returns(user)
  end

  def unstub_current_user
    @controller.class.any_instance.unstub(:set_user_by_token)
  end

end
