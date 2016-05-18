require 'test_helper'

class PoiTest < ActiveSupport::TestCase

  test 'should create poi' do
    assert_difference 'Poi.count' do
      poi = Poi.new
      assert poi.save, poi.errors.full_messages
      assert_nil poi.creator
    end
  end

end
