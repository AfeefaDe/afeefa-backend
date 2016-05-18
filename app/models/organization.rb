class Organization < ActiveRecord::Base
  has_many :roles
  has_many :users, through: :roles

  has_and_belongs_to_many :categories

  has_and_belongs_to_many :tags

  has_many :locations

  validates_presence_of :title
  validates_length_of :title, minimum: 5
end
