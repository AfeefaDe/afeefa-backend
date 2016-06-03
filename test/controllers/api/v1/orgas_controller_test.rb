require 'test_helper'

class Api::V1::OrgasControllerTest < ActionController::TestCase

  context 'As orga' do
    setup do
      user = create(:admin)
      stub_current_user(user: user)

      @orga = user.orgas.first
      @user_json = {forename: 'Rudi', surname: 'Dutschke', email: 'bob@afeefa.de'}
    end

    should 'create new member in orga' do
      assert_difference '@orga.users.count' do
        post :create_member, id: @orga.id, user: @user_json
        assert_response :created
      end

      assert_equal @user_json[:email], @orga.users.last.email

    end

  end


end
