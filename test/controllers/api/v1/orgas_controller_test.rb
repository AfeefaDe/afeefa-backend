require 'test_helper'

class Api::V1::OrgasControllerTest < ActionController::TestCase

  context 'As Admin' do
    setup do
      user = create(:admin)
      stub_current_user(user: user)

      @orga = user.orgas.first
      @user_json = {forename: 'Rudi', surname: 'Dutschke', email: 'bob@afeefa.de'}
    end

    should 'I want to create a new member in orga' do
      assert_difference '@orga.users.count' do
        post :create_member, id: @orga.id, user: @user_json
        assert_response :created
      end

      assert_equal @user_json[:email], @orga.users.last.email
    end

    should 'I must not create a new member in a not existing orga' do
      assert_no_difference 'User.count' do
        post :create_member, id: Orga.last.id + 1, user: @user_json
        assert_response :not_found
      end
    end

    should 'I must not create a new member in an orga I am no admin in' do
      assert_no_difference 'User.count' do
        post :create_member, id: create(:another_orga), user: @user_json
        assert_response :unauthorized
      end
    end

    should 'I must not create a new user that already exists' do
      @user = create(:user)
      assert_no_difference 'User.count' do
        post :create_member, id: @orga.id, user: {forename: 'a', surname: 'b', email: @user.email}
        assert_response :unprocessable_entity
      end
    end

  end

end