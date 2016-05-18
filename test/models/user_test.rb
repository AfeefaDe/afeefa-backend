require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = FactoryGirl.create(:valid_user)
  end

  test 'user should have some basic attributes not nil' do
    assert @user.respond_to? :password
    assert @user.has_attribute? :email
    assert @user.has_attribute? :registered_at

  end

  test 'user should have some basic attributes' do
    assert @user.has_attribute? :access_token
    assert @user.has_attribute? :forename
    assert @user.has_attribute? :surname
    assert @user.has_attribute? :last_sign_in_at
    assert @user.has_attribute? :gender
    assert @user.has_attribute? :degree
    assert @user.has_attribute? :activated_at
    assert @user.has_attribute? :enabled_at
  end

  test 'user should have a spoken language' do
    skip 'noch nicht implementiert'
    assert @user.has_attribute? :spoken_language
  end

  test 'user may have translator languages' do
    skip 'noch nicht implementiert'
    assert @user.has_attribute? :spoken_language
  end

  test 'user should have organizations' do
    orga = FactoryGirl.create(:organization)
    role = FactoryGirl.build(:role, organization: orga, user: @user)
    @user.roles << role
    assert_equal 1, @user.organizations.size
    assert_equal orga, @user.organizations.first
  end

  test 'user should have contact information' do
    skip 'needs to be implemented'
  end

  test 'user should have role for organization' do
    assert orga = FactoryGirl.create(:organization)
    assert @user.save
    role = Role.new(title: Role::ORGA_ADMIN, organization: orga, user: @user)
    assert role.save

    assert @user.reload.orga_admin?(orga)
    assert !@user.reload.orga_user?(orga)
  end

  test 'user should be owner of things' do
    market_entry = nil
    assert_difference('MarketEntry.count') do
      market_entry = FactoryGirl.create(:market_entry)
    end

    assert_difference('@user.reload.market_entries.count') do
      assert_difference('@user.owner_thing_relations.count') do
        assert_difference('OwnerThingRelation.count') do
          OwnerThingRelation.create(ownable: market_entry, thingable: @user)
        end
      end
    end
  end

  test 'user should be creator of things' do
    assert_difference('@user.created_market_entries.count') do
      market_entry = FactoryGirl.create(:market_entry, creator: @user)
      assert_equal @user, market_entry.creator
    end
  end

end
