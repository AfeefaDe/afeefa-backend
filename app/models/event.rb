class Event < ActiveRecord::Base

  include Entry

  belongs_to :meta_event
  has_many :sub_events, class_name: 'Event', foreign_key: :meta_event_id

end
