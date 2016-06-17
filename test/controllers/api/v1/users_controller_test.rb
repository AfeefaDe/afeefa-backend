require 'test_helper'

class Api::V1::UsersControllerTest < ActionController::TestCase
  context 'As user' do
    should 'I want a list of all my orgas' do
      assert_routing 'api/v1/users/1/orgas', controller: 'api/v1/users', action: 'list_orgas', id: '1'
    end
  end
end
