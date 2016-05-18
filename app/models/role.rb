class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization

  ORGA_ADMIN = 'orga_admin'
  ORGA_USER = 'orga_user'
  ROLES = [ORGA_ADMIN, ORGA_USER]

  validates_inclusion_of :title, within: ROLES
  validates_presence_of :user, :organization
end
