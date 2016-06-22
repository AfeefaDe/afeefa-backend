require 'test_helper'

class Api::V1::UsersControllerTest < ActionController::TestCase

  should 'render json api spec for orga list' do
    admin = create(:admin)
    stub_current_user(user: admin)
    orga = admin.orgas.first

    get :list_orgas, id: admin.id
    assert_response :success
    assert_equal [orga.to_jsonapi_hash].to_json, response.body
  end

end
