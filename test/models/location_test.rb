require 'test_helper'

class LocationTest < ActiveSupport::TestCase

  test 'should validate scope' do
    loc = Location.new
    assert !loc.valid?
    assert loc.errors[:scope].any?

    loc.scope = 'blubb'
    assert !loc.valid?
    assert loc.errors[:scope].any?

    Location::SCOPES.each do |scope|
      loc.scope = scope
      assert loc.valid?, loc.errors.full_messages
    end
  end

  test 'should belongs_to orga' do
    loc = Location.new(scope: Location::SCOPES.first)
    assert_nil loc.organization

    orga = FactoryGirl.create(:organization)
    loc.organization = orga
    assert_equal orga.id, loc.organization_id
  end

end
