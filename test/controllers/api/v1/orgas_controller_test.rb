require 'test_helper'

class Api::V1::OrgasControllerTest < ActionController::TestCase

  context 'As orga' do
    setup do
      Settings.api.stubs(:allow_token_as_param).returns(true)

      @orga = create(:orga)
      @user_json = {user: {forename: 'Rudi', surname: 'Dutschke', email: 'bob@afeefa.de'}}
    end

    should 'create new member in orga' do
      assert_difference '@orga.users.count' do
        post :create_member, id: @orga.id, user: @user_json
        assert_response :created
      end

      assert_equal @user_json[user][email], @orga.users.first

    end

  end


end
