class OrgaSerializer < BaseSerializer

  attribute 'title'
  attribute 'description'
  attribute 'logo'
  attribute 'support_wanted'
  attribute 'created_at'
  attribute 'updated_at'

  has_many :users
end
