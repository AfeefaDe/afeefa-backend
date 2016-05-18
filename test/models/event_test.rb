require 'test_helper'

class EventTest < ActiveSupport::TestCase

  test 'should create event' do
    assert_difference 'Event.count' do
      event = Event.new
      assert event.save, event.errors.full_messages
      assert_nil event.creator
      assert_nil event.meta_event
      assert_empty event.sub_events
    end
  end

end
