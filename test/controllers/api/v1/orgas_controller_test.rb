require 'test_helper'

class Api::V1::OrgasControllerTest < ActionController::TestCase

  context 'As Admin' do
    setup do
      @admin = create(:admin)
      stub_current_user(user: @admin)

      @orga = @admin.orgas.first
      @user_json = {forename: 'Rudi', surname: 'Dutschke', email: 'bob@afeefa.de'}
    end

    should 'I want to create a new member in orga' do
      assert_difference '@orga.users.count' do
        post :create_member, id: @orga.id, user: @user_json
        assert_response :created
      end

      assert_equal @user_json[:email], @orga.users.last.email
    end

    context 'interacting with a member' do
      setup do
        @member = create(:member, orga: @admin.orgas.first)
        @user = create(:user)
      end

      should 'try to remove user from orga' do
        @admin.expects(:remove_user_from_orga).once
        delete :remove_member, id: @orga.id, user_id: @member.id
      end

      should 'remove user from orga' do
        delete :remove_member, id: @orga.id, user_id: @member.id
        assert_response :ok
      end

      should 'remove user from orga, am not admin' do
        stub_current_user(user: @user)

        delete :remove_member, id: @orga.id, user_id: @member.id
        assert_response :forbidden
      end

      should 'remove user from orga, user not in orga' do
        delete :remove_member, id: @orga.id, user_id: @user.id
        assert_response :not_found
      end

      should 'I want to promote a member to admin, user is not in orga' do
        put :promote_member, id: @orga.id, user_id: @user.id
        assert_response :not_found
      end

      should 'I want to promote a member to admin, am not admin' do
        stub_current_user(user: @user)

        put :promote_member, id: @orga.id, user_id: @member.id
        assert_response :forbidden
      end

      should 'I want to promote a member to admin, a)' do
        put :promote_member, id: @orga.id, user_id: @member.id
        assert_response :ok
      end

      should 'I want to promote a member to admin, b)' do
        @admin.expects(:promote_member_to_admin).once
        put :promote_member, id: @orga.id, user_id: @member.id
      end

      should 'I want to demote an admin to member, user is not in orga' do
        put :demote_admin, id: @orga.id, user_id: @user.id
        assert_response :not_found
      end

      should 'I want to demote an admin to member, am not admin' do
        stub_current_user(user: @user)

        put :demote_admin, id: @orga.id, user_id: @member.id
        assert_response :forbidden
      end

      should 'I want to demote an admin to member, a)' do
        put :demote_admin, id: @orga.id, user_id: @member.id
        assert_response :ok
      end

      should 'I want to demote an admin to member, b)' do
        @admin.expects(:demote_admin_to_member).once
        put :demote_admin, id: @orga.id, user_id: @member.id
      end
    end

    should 'I must not create a new member in a not existing orga' do
      assert_no_difference 'User.count' do
        post :create_member, id: 'not existing id', user: @user_json
        assert_response :not_found
      end
    end

    should 'I must not create a new member in an orga I am no admin in' do
      assert_no_difference 'User.count' do
        post :create_member, id: create(:another_orga).id, user: @user_json
        assert_response :forbidden
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

  context 'As member' do
    should 'I want a list of all members in the corresponding orga' do
      assert_routing 'api/v1/orgas/1/users', controller: 'api/v1/orgas', action: 'list_members', id: '1'
    end
  end
end
