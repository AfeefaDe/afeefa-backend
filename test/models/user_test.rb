require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context 'As user' do
    setup do
      @user = create(:user)
    end

    should 'have some basic attributes not nil' do
      assert @user.respond_to? :password
      assert @user.has_attribute? :email
      assert @user.has_attribute? :registered_at

    end

    should 'have some basic attributes' do
      assert @user.has_attribute? :access_token
      assert @user.has_attribute? :forename
      assert @user.has_attribute? :surname
      assert @user.has_attribute? :last_sign_in_at
      assert @user.has_attribute? :gender
      assert @user.has_attribute? :degree
      assert @user.has_attribute? :activated_at
      assert @user.has_attribute? :enabled_at
    end

    should 'have a spoken language' do
      skip 'noch nicht implementiert'
      assert @user.has_attribute? :spoken_language
    end

    should 'have translator languages' do
      skip 'noch nicht implementiert'
      assert @user.has_attribute? :spoken_language
    end

    should 'have orgas' do
      orga = create(:orga)
      role = build(:role, orga: orga, user: @user)
      @user.roles << role
      assert_equal 1, @user.reload.orgas.size
      assert_equal orga, @user.orgas.first
    end

    should 'have contact information' do
      skip 'needs to be implemented'
    end

    should 'have role for orga' do
      assert orga = create(:orga)
      assert @user.save
      role = Role.new(title: Role::ORGA_ADMIN, orga: orga, user: @user)
      assert role.save

      assert @user.reload.orga_admin?(orga)
      assert !@user.reload.orga_member?(orga)
    end

    should 'be owner of things' do
      market_entry = nil
      assert_difference('MarketEntry.count') do
        market_entry = create(:market_entry)
      end

      assert_difference('@user.reload.market_entries.count') do
        assert_difference('@user.owner_thing_relations.count') do
          assert_difference('OwnerThingRelation.count') do
            OwnerThingRelation.create(ownable: market_entry, thingable: @user)
          end
        end
      end
    end

    should 'be creator of things' do
      assert_difference('@user.created_market_entries.count') do
        market_entry = create(:market_entry, creator: @user)
        assert_equal @user, market_entry.creator
      end
    end

  context 'As user' do

    should 'I want to update my data to keep it up to date' do
      assert_no_difference('User.count') do
        new_forename = @user.forename+'123'
        new_surname = @user.surname+'123'
        assert_not_equal new_forename, @user.forename
        assert_not_equal new_surname, @user.surname
        @user.update(forename: new_forename, surname: new_surname)
        assert_equal new_forename, @user.forename
        assert_equal new_surname, @user.surname
      end
    end

  end

  context 'As admin' do
    setup do
      @admin = create(:admin)
      @orga = @admin.orgas.first
      @member = create(:member, orga: @admin.organizations.first)
    end

    should 'I want to create a user to add it to orga' do
      assert_difference('User.count') do
        assert_difference('@admin.organizations.first.users.count') do
          @admin.create_user_and_add_to_orga(email: 'team@afeefa.de', forename: 'Afeefa', surname: 'Team', orga: @admin.organizations.first)
        end
      end

      new_user = User.last
      assert_equal(@admin.organizations.first, new_user.organizations.first)
    end


    context 'As admin, interact with orga' do
      setup do
        @member = create(:member, orga: @admin.organizations.first)
      end

    should 'I want to create a new user to add it to my orga' do
      @orga.expects(:add_new_member).once
      User.expects(:create!).once

      @admin.create_user_and_add_to_orga(email: 'team@afeefa.de', forename: 'Afeefa', surname: 'Team', orga: @orga)

    end

    context 'interacting with a member' do
      setup do
        @member = create(:member, orga: @admin.orgas.first)
        @user = create(:user)
      end

      should 'I want to remove a user from an orga. i am not admin' do
        assert_raise CanCan::AccessDenied do
          assert_no_difference('@admin.orgas.first.users.count') do
            @user.remove_user_from_orga(member: @member, orga: @admin.orgas.first)
          end
        end
      end

      should 'I want to remove a user from an orga. user is in orga' do
        assert_difference('@admin.orgas.first.users.count', -1) do
          @admin.remove_user_from_orga(member: @member, orga: @admin.orgas.first)
        end
        refute(@member.orga_member?(@admin.orgas.first) || @member.orga_admin?(@admin.orgas.first))
      end

      should 'I want to remove a user from an orga. user is not in orga' do
        assert_raise ActiveRecord::RecordNotFound do
          assert_no_difference('@admin.orgas.first.users.count') do
            @admin.remove_user_from_orga(member: @user, orga: @admin.orgas.first)
          end
        end
      end
    end
  end

  context 'As member' do
    setup do
      @member = create(:member)
      @orga = @member.orgas.first
    end
    should 'I must not add a new user to an orga' do

      @orga.expects(:add_new_member).never

      assert_no_difference('User.count') do
        assert_raise CanCan::AccessDenied do
          @member.create_user_and_add_to_orga(email: 'foo@afeefa.de', forename: 'Afeefa', surname: 'Team', orga: @orga)
        end
      end
    end

  end

end
