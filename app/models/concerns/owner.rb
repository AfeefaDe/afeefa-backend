module Owner

  extend ActiveSupport::Concern

  included do
    # has_many :mailtemplates
    has_many :contact_infos, as: :contactable

    has_many :owner_thing_relations, as: :thingable
    has_many :market_entries, through: :owner_thing_relations, source: :ownable, source_type: 'MarketEntry'
    has_many :events, through: :owner_thing_relations, source: :ownable, source_type: 'Event'
    has_many :pois, through: :owner_thing_relations, source: :ownable, source_type: 'Poi'
  end

end
