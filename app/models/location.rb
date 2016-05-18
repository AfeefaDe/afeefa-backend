class Location < ActiveRecord::Base

  DISTRICT = 'district'
  CITY = 'city'
  STATE = 'state'
  COUNTRY = 'country'
  SCOPES = [DISTRICT, CITY, STATE, COUNTRY]

  belongs_to :organization

  belongs_to :locateable

  validates_inclusion_of :scope, in: SCOPES

end
