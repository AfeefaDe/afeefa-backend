class ThingCategoryRelation < ActiveRecord::Base
  belongs_to :catable, polymorphic: true
  belongs_to :category
end
