require 'test_helper'

class PingTest < ActiveSupport::TestCase

  should 'have method find_by_id' do
    Timecop.freeze do
      assert_equal Time.current.to_s, Ping.new.pong
      assert_equal Time.current.to_s, Ping.find_by_id(123).pong
    end
  end

  should 'be conform to json api spec' do
    Timecop.freeze do
      hash = JSON.parse(Ping.new.to_jsonapi_hash.to_json).deep_symbolize_keys
      assert hash.key?(:data)
      assert hash[:data].key?(:attributes)
      assert hash[:data][:attributes].key?(:pong)
      assert_equal Time.current.to_s, hash[:data][:attributes][:pong]
    end
  end

end
