require 'test_helper'

class OrgaTest < ActiveSupport::TestCase

  setup do
    @my_orga = Orga.new
  end

  test 'orga attributes' do
    nil_defaults = [:title, :description, :api_key, :logo]
    false_defaults = [:support_wanted, :api_access]
    (nil_defaults + false_defaults).each do |attr|
      assert @my_orga.respond_to?(attr), "orga does not respond to #{attr}"
    end
    nil_defaults.each do |attr|
      assert_equal nil, @my_orga.send(attr)
    end
    false_defaults.each do |attr|
      assert !@my_orga.send(attr)
      assert !@my_orga.send("#{attr}?")
    end
  end

  test 'save orga' do
    assert_no_difference 'Orga.count' do
      assert !@my_orga.save
    end

    @my_orga.title = '12345'
    assert_difference 'Orga.count' do
      assert @my_orga.save
    end
  end

  test 'orga title length' do
    @my_orga.title = '123'
    assert !@my_orga.valid?

    @my_orga = build(:orga)
    assert @my_orga.valid?
  end

  context 'As admin' do
    setup do
      @user = create(:admin)
    end

    should 'I want to add a new member to my orga' do
      new_user = create(:user)
      orga = @user.orgas.first

      assert_difference('orga.users.count') do
        orga.add_new_member(new_member: new_user, admin: @user)
      end

      assert_equal(orga, new_user.reload.orgas.first)
    end

    should 'I must not add a new member to a foreign orga' do
      new_user = create(:user)
      orga = create(:another_orga)

      assert_no_difference('new_user.orgas.count') do
        assert_no_difference('orga.users.count') do
          assert_raise CanCan::AccessDenied do
            orga.add_new_member(new_member: new_user, admin: @user)
          end
        end
      end
    end

    should 'I must not add the same member to my orga again' do
      new_user = create(:user)
      orga = @user.orgas.first

      orga.add_new_member(new_member: new_user, admin: @user)

      assert_no_difference('orga.users.count') do
        assert_no_difference('new_user.orgas.count') do
          assert_raise UserIsAlreadyMemberException do
            orga.add_new_member(new_member: new_user, admin: @user)
          end
        end
      end
    end

    should 'have associated orgas' do
      orga = create(:orga)
      another_orga = create(:another_orga)

      assert_empty orga.suborgas
      assert_empty another_orga.suborgas

      orga.suborgas << another_orga
      orga.reload.suborgas
      assert_includes orga.reload.suborgas, another_orga
      assert_equal orga, another_orga.reload.parent_orga
    end

    should 'I want to add a new suborga to my orga' do
      new_orga = create(:orga)
      orga = @user.orgas.first

      assert_difference('orga.suborgas.count') do
        orga.add_new_suborga(new_suborga: new_orga, admin: @user)
      end

      assert_equal(orga, new_orga.reload.parent_orga)
    end

    should 'I must not add a new suborga to a foreign orga' do
      new_orga = create(:orga)
      orga = create(:another_orga)

      assert_no_difference('orga.suborgas.count') do
        assert_raise CanCan::AccessDenied do
          orga.add_new_suborga(new_suborga: new_orga, admin: @user)
        end
      end

      assert_nil new_orga.reload.parent_orga
    end

    should 'I must not add the same suborga to my orga again' do
      new_orga = create(:orga)
      orga = @user.orgas.first

      orga.add_new_suborga(new_suborga: new_orga, admin: @user)

      assert_no_difference('orga.suborgas.count') do
        assert_raise OrgaIsAlreadySuborgaException do
          orga.add_new_suborga(new_suborga: new_orga, admin: @user)
        end
      end
    end
  end

end
