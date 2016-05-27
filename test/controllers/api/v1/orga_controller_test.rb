require 'test_helper'

class Api::V1::OrgaControllerTest < ActionController::TestCase

  should 'create new member in orga' do
    post :add_member
  end

end
