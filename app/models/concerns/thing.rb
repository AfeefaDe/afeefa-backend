module Thing

  extend ActiveSupport::Concern

  included do
    has_many :owner_thing_relations, as: :ownable
    has_many :users, through: :owner_thing_relations, source: :thingable, source_type: 'User'
    has_many :orgas, through: :owner_thing_relations, source: :thingable, source_type: 'Orga'

    has_many :thing_category_relations
    has_many :categories, through: :thing_category_relation

    has_many :thing_tag_relations
    has_many :tags, through: :thing_tag_relations

    belongs_to :creator, class_name: 'User'
  end

end
