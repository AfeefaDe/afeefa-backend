require 'test_helper'

class Api::V1::UsersControllerTest < ActionController::TestCase
  context 'As user' do
    should 'I want a list of all my orgas' do
      assert_routing 'api/v1/users/1/orgas', controller: 'api/v1/users', action: 'list_orgas', id: '1'
    end
  end

  should 'render json api spec for orga list' do
    admin = create(:admin)
    stub_current_user(user: admin)
    orga = admin.orgas.first

    get :list_orgas, id: admin.id
    assert_response :success
    expected = OrgaSerializer.serialize([orga], is_collection: true).to_json
    assert_equal expected, response.body
  end

end
