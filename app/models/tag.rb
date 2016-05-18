class Tag < ActiveRecord::Base
  has_and_belongs_to_many :organizations

  has_many :thing_tag_relations, as: :tagable
  has_many :market_entries, through: :thing_tag_relations, source: :tagable, source_type: 'MarketEntry'
  has_many :events, through: :thing_tag_relations, source: :tagable, source_type: 'Event'
  has_many :pois, through: :thing_tag_relations, source: :tagable, source_type: 'Poi'
end
