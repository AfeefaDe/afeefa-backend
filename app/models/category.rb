class Category < ActiveRecord::Base
  belongs_to :meta_category
  has_many :sub_categories, class_name: 'Category', foreign_key: :meta_category_id

  has_and_belongs_to_many :orgas

  has_many :thing_category_relation, as: :catable
  has_many :market_entries, through: :thing_category_relation, source: :catable, source_type: 'MarketEntry'
  has_many :events, through: :thing_category_relation, source: :catable, source_type: 'Event'
  has_many :pois, through: :thing_category_relation, source: :catable, source_type: 'Poi'
end
