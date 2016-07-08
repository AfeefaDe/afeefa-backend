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

      should 'I want to try to remove a user from orga' do
        @admin.expects(:remove_user_from_orga).once
        delete :remove_member, id: @orga.id, user_id: @member.id
      end

      should 'I want to remove a user from orga' do
        delete :remove_member, id: @orga.id, user_id: @member.id
        assert_response :ok
      end

      should 'I want to remove a user from orga, am not admin, not myself' do
        stub_current_user(user: @user)

        delete :remove_member, id: @orga.id, user_id: @member.id
        assert_response :forbidden
      end

      should 'I want remove a user from orga, the user not in orga' do
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
    setup do
      @member = create(:member, orga: build(:orga))
      @orga = @member.orgas.first
      stub_current_user(user: @member)
    end

    should 'I want a list of all members in the corresponding orga' do
      assert_routing 'api/v1/orgas/1/users', controller: 'api/v1/orgas', action: 'list_members', id: '1'
    end

    should 'render json api spec for user list' do
      get :list_members, id: @orga.id
      assert_response :success
      expected = UserSerializer.serialize([@member], is_collection: true).to_json
      assert_equal expected, response.body
    end

    should 'I want to leave orga' do
      delete :remove_member, id: @orga.id, user_id: @member.id
      assert_response :success
    end

    should 'I want to update the data of the orga' do
      desc = @orga[:description]
      patch :update, id: @orga.id, data: {type: 'orga', id: @orga.id, attributes: {title: 'newTitle', logo: 'newLogo.png'}}
      assert_response :success
      @orga.reload
      assert_equal @orga[:title], 'newTitle'
      assert_equal @orga[:logo], 'newLogo.png'
      assert_equal @orga[:description], desc
    end
  end

  context 'As user' do
    setup do
      @user = create(:user)
      @orga = create(:orga)
      stub_current_user(user: @user)
    end

    should 'I want a list of all members in an orga, I am not member in orga' do
      get :list_members, id: @orga.id
      assert_response :forbidden
    end

    should 'I want to update the data of some orga, I am not member in orga' do
      desc = @orga[:description]
      upd = @orga[:updated_at]
      patch :update, id: @orga.id, data: {type: 'orga', id: @orga.id, attributes: {title: 'newTitle', logo: 'newLogo.png'}}
      assert_response :forbidden
      @orga.reload
      assert_not_equal @orga[:title], 'newTitle'
      assert_not_equal @orga[:logo], 'newLogo.png'
      assert_equal @orga[:description], desc
      assert_in_delta @orga[:updated_at], upd, 0.0001
    end
  end

end
