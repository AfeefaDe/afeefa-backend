class UserSerializer < BaseSerializer

  attribute 'email'
  attribute 'forename'
  attribute 'surname'

  has_many :orgas
end
