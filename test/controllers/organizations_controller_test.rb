require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase

  setup do
    @organization = FactoryGirl.create(:organization)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:organizations)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create organization' do
    assert_difference('Organization.count') do
      post :create, organization: { title: '12345' }
    end
    assert_redirected_to organization_path(assigns(:organization))
  end
  
  test 'should return error if organization title is too short' do
    assert_no_difference('Organization.count') do
      post :create, organization: { title: '123' }, format: :json
    end

    assert_response :unprocessable_entity

    assert_difference('Organization.count') do
      post :create, organization: { title: '12345' }, format: :json
    end

    assert_response :success
  end

  test 'should show organization' do
    get :show, id: @organization
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @organization
    assert_response :success
  end

  test 'should update organization' do
    patch :update, id: @organization, organization: { title: '12345' }
    assert_redirected_to organization_path(assigns(:organization))
  end

  test 'should not update organization if invalid' do
    patch :update, id: @organization, organization: { title: '---' }
    assert_response :success
    assert !assigns(:organization).valid?
    assert assigns(:organization).errors[:title].any?
  end

  test 'should destroy organization' do
    assert_difference('Organization.count', -1) do
      delete :destroy, id: @organization
    end
    assert_redirected_to organizations_path
  end

end
