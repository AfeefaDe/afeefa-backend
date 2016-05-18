require 'test_helper'

class MarketEntryTest < ActiveSupport::TestCase

  test 'should create market entry' do
    assert_difference 'MarketEntry.count' do
      market_entry = MarketEntry.new
      assert market_entry.save, market_entry.errors.full_messages
      assert_nil market_entry.creator
    end
  end

end
