require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:valid_user)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create user' do
    assert_difference('User.count') do
      post :create, user: { email: 'abc@example.com', password: 'test1234!'}
      assert (user = assigns(:user)).valid?, user.errors.full_messages
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test 'should handle create user error' do
    User.any_instance.stubs(:save).returns(false)

    assert_no_difference('User.count') do
      post :create, user: { email: 'abc@example.com', password: 'test1234!'}
    end

    assert_response :success
    assert_template :new
  end

  test 'should show user' do
    get :show, id: @user
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @user
    assert_response :success
  end

  test 'should update user' do
    assert_no_difference('User.count') do
      patch :update, id: @user, user: { email: 'neu@exmaple.com' }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test 'should handle update user error' do
    User.any_instance.stubs(:save).returns(false)

    assert_no_difference('User.count') do
      patch :update, id: @user, user: { email: 'neu@exmaple.com' }
    end

    assert_response :success
    assert_template :edit
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end

end
